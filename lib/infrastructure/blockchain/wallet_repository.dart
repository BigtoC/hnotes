import "dart:convert";

import "package:blockchain_utils/utils/binary/bytes_tracker.dart";
import "package:cosmos_sdk/cosmos_sdk.dart";
import "package:hnotes/infrastructure/blockchain/address_repository.dart";
import "package:hnotes/infrastructure/blockchain/blockchain_info_repository.dart";
import "package:hnotes/infrastructure/constants.dart";
import "package:hnotes/infrastructure/local_storage/secrets/secrets_repository.dart";
import "package:mantrachain_dart_sdk/api.dart" as mantra;

/// Function type for transaction confirmation callback
typedef TransactionConfirmationCallback = Future<bool> Function({
  required String sender,
  required List<CosmosMessage> messages,
  required Fee transactionFee,
});

class WalletRepository {
  final AddressRepository _addressRepository;
  final BlockchainInfoRepository _blockchainInfoRepository;
  final SecretsRepository _secretsRepository;
  final mantra.ServiceApi _serviceApi;

  /// Constructor that accepts dependencies, making the class more testable
  WalletRepository({
    AddressRepository? addressRepository,
    BlockchainInfoRepository? blockchainInfoRepository,
    SecretsRepository? secretsRepository,
    mantra.ServiceApi? serviceApi,
  }) :
    _addressRepository = addressRepository ?? AddressRepository(),
    _blockchainInfoRepository = blockchainInfoRepository
        ?? BlockchainInfoRepository(),
    _secretsRepository = secretsRepository ?? SecretsRepository(),
    _serviceApi = serviceApi ??
        mantra.ServiceApi(mantra.ApiClient(basePath: chainRestUrl));

  factory WalletRepository.withDefaults() {
    return WalletRepository();
  }

  /// Signs and broadcasts a transaction with optional confirmation
  ///
  /// If a [confirmTransaction] callback is provided,
  /// it will be called before broadcasting
  /// to allow the user to confirm the transaction.
  /// If the callback returns false,
  /// the transaction will not be broadcast.
  Future<String?> signAndBroadcast(
      String sender,
      List<CosmosMessage> messages,
      {TransactionConfirmationCallback? confirmTransaction}
  ) async {
    try {
      // Build the transaction
      final tx = await buildTx(sender, messages);

      final txBody = tx["txBody"] as TXBody;
      final authInfo = tx["authInfo"] as AuthInfo;
      final signDoc = tx["signDoc"] as SignDoc;
      final fee = authInfo.fee;

      // Request user confirmation if callback is provided
      if (confirmTransaction != null) {
        final isConfirmed = await confirmTransaction(
          sender: sender,
          messages: messages,
          transactionFee: fee,
        );

        if (!isConfirmed) {
          print("Transaction cancelled by user");
          return null;
        }
      }

      // Retrieve signing key and sign the transaction
      try {
        final signKey = await _secretsRepository.retrieveSignKey();

        final signed = signKey.sign(signDoc.toBuffer());

        final txRaw = TxRaw(
          bodyBytes: txBody.toBuffer(),
          authInfoBytes: authInfo.toBuffer(),
          signatures: [signed],
        );

        print("Signed transaction: ${txRaw.txId()}");

        // Broadcast the transaction
        try {
          final result = await _serviceApi.broadcastTx(
            mantra.BroadcastTxRequest(
              txBytes: base64.encode(txRaw.toBuffer()),
              mode: mantra.BroadcastTxRequestModeEnum.BROADCAST_MODE_ASYNC,
            ),
          );

          if (result == null || result.txResponse == null) {
            print("Error: Broadcast returned null response");
            return null;
          }

          // Check if there's an error code in the response
          if (result.txResponse?.code != null && result.txResponse!.code! > 0) {
            print(
                "Transaction error code: ${result.txResponse!.code}, "
                    "message: ${result.txResponse!.rawLog}"
            );
          }

          final txHash = result.txResponse?.txhash;
          return txHash;
        } catch (e) {
          print("Error broadcasting transaction: ${e.toString()}");
          return null;
        }
      } catch (e) {
        print("Error signing transaction: ${e.toString()}");
        return null;
      }
    } catch (e) {
      print("Error in signAndBroadcast: ${e.toString()}");
      return null;
    }
  }

  Future<Map<dynamic, dynamic>> buildTx(
    String sender,
    List<CosmosMessage> messages,
  ) async {
    final chainResults = await Future.wait(
      [
        _blockchainInfoRepository.fetchNodeInfo(),
        _blockchainInfoRepository.fetchGasPrice(),
        _addressRepository.fetchAccountInfo(sender),
        _secretsRepository.getImportedPublicKey(),
      ] as Iterable<Future>,
    );

    if (chainResults.length != 4) {
      throw Exception("Failed to fetch all required blockchain info");
    }

    final nodeInfo = chainResults[0];
    final gasPrice = chainResults[1];
    final mantra.AccountInfo200Response accountInfo = chainResults[2];
    final CosmosSecp256K1PublicKey? publicKey = chainResults[3];

    final chainId = nodeInfo["chainId"];
    final accountNumber = BigInt.from(
      int.parse(accountInfo.info?.accountNumber ?? "0"),
    );
    final sequence = BigInt.from(int.parse(accountInfo.info?.sequence ?? "0"));

    final memo = "Sent from Flutter app";

    /// Creating transaction body with the message
    final txBody = TXBody(messages: messages, memo: memo);

    /// Simulate transaction to get gas estimation
    /// gasLimit = gasEstimation * gasPrice["amount"]
    final gasEstimation = await _simulateTx(
      txBody,
      memo,
      publicKey!,
      sequence,
      chainId,
    );

    print(
      "Gas used: ${gasEstimation?.gasUsed}, "
      "Gas wanted: ${gasEstimation?.gasWanted}",
    );

    final fee = calculateFee(gasPrice["amount"], gasEstimation!);
    final authInfo = _buildAuthInfo(publicKey, sequence, fee);

    /// Creating a sign document for the transaction
    final signDoc = SignDoc(
      bodyBytes: txBody.toBuffer(),
      authInfoBytes: authInfo.toBuffer(),
      chainId: chainId,
      accountNumber: accountNumber,
    );
    return {"signDoc": signDoc, "txBody": txBody, "authInfo": authInfo};
  }

  // Reference: https://github.com/cosmos/cosmjs/blob/main/packages/stargate/src/modules/tx/queries.ts
  Future<mantra.Simulate200ResponseGasInfo?> _simulateTx(
    TXBody txBody,
    String? memo,
    CosmosSecp256K1PublicKey publicKey,
    BigInt sequence,
    String chainId,
  ) async {
    final authInfo = _buildAuthInfo(publicKey, sequence, Fee(amount: []));

    final txRaw = TxRaw(
      bodyBytes: txBody.toBuffer(),
      authInfoBytes: authInfo.toBuffer(),
      signatures: [DynamicByteTracker().toBytes()],
    );

    final mantra.Simulate200Response? gasEstimation = await _serviceApi
        .simulate(
          mantra.CosmosTxV1beta1SimulateRequest(
            txBytes: base64.encode(txRaw.toBuffer()),
          ),
        );
    if (gasEstimation == null || gasEstimation.gasInfo == null) {
      throw Exception("Failed to estimate gas");
    } else {
      return gasEstimation.gasInfo;
    }
  }

  AuthInfo _buildAuthInfo(
      CosmosSecp256K1PublicKey publicKey,
      BigInt sequence, Fee fee
      ) {
    return AuthInfo(
      signerInfos: [
        SignerInfo(
          publicKey: publicKey.toAny(),
          modeInfo: const ModeInfo(ModeInfoSignle(SignMode.signModeDirect)),
          sequence: sequence,
        ),
      ],
      fee: fee,
    );
  }

  /// Reference: https://github.com/cosmos/cosmjs/blob/main/packages/stargate/src/fee.ts
  Fee calculateFee(
    String gasPriceStr,
    mantra.Simulate200ResponseGasInfo gasInfo,
  ) {
    final gasPrice = double.parse(gasPriceStr);
    final gasLimit = double.parse(
        gasInfo.gasUsed ?? defaultGasUsed
    ) * gasLimitMultiplier;

    final gasAmount = gasPrice * gasLimit;

    return Fee(
      amount: [
        Coin(
            denom: feeDenom,
            amount: BigInt.from(gasAmount.floor())
        )
      ],
      gasLimit: BigInt.parse(gasLimit.toStringAsFixed(0)),
    );
  }
}
