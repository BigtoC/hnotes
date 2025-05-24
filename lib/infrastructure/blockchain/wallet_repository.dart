import "dart:convert";

import "package:blockchain_utils/utils/binary/bytes_tracker.dart";
import "package:cosmos_sdk/cosmos_sdk.dart";
import "package:hnotes/infrastructure/blockchain/address_repository.dart";
import "package:hnotes/infrastructure/blockchain/blockchain_info_repository.dart";
import "package:hnotes/infrastructure/constants.dart";
import "package:hnotes/infrastructure/local_storage/secrets/secrets_repository.dart";
import "package:mantrachain_dart_sdk/api.dart" as mantra;

class WalletRepository {
  final AddressRepository _addressRepository = AddressRepository();
  final BlockchainInfoRepository _blockchainInfoRepository =
      BlockchainInfoRepository();
  final SecretsRepository _secretsRepository = SecretsRepository();
  final _serviceApi = mantra.ServiceApi(
    mantra.ApiClient(basePath: chainRestUrl),
  );

  Future<String?> signAndBroadcast(String sender, List<CosmosMessage> messages) async {
    final tx = await buildTx(sender, messages);
    final txBody = tx["txBody"] as TXBody;
    final authInfo = tx["authInfo"] as AuthInfo;
    final signDoc = tx["signDoc"] as SignDoc;
    final signKey = await _secretsRepository.retrieveSignKey();
    final signed = signKey.sign(signDoc.toBuffer());

    final txRaw = TxRaw(
      bodyBytes: txBody.toBuffer(),
      authInfoBytes: authInfo.toBuffer(),
      signatures: [signed],
    );

    final result = await _serviceApi.broadcastTx(
      mantra.BroadcastTxRequest(
        txBytes: base64.encode(txRaw.toBuffer()),
        mode: mantra.BroadcastTxRequestModeEnum.BROADCAST_MODE_ASYNC,
      ),
    );
    print(result);
    final txHash = result?.txResponse?.txhash;
    return txHash;
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
          ]
          as Iterable<Future>,
    );

    final nodeInfo = chainResults[0];
    final gasPrice = chainResults[1];
    final mantra.AccountInfo200Response accountInfo = chainResults[2];

    final CosmosSecp256K1PublicKey? publicKey = await _secretsRepository.getImportedPublicKey();

    final chainId = nodeInfo["chainId"];
    final accountNumber = BigInt.from(
      int.parse(accountInfo.info?.accountNumber ?? "0"),
    );
    final sequence = BigInt.from(int.parse(accountInfo.info?.sequence ?? "0"));

    final memo = "Flutter Test";

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

    final fee = _calculateFee(gasPrice["amount"], gasEstimation!);
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

  _buildAuthInfo(CosmosSecp256K1PublicKey publicKey, BigInt sequence, Fee fee) {
    return AuthInfo(
      signerInfos: [
        SignerInfo(
          publicKey: publicKey,
          modeInfo: const ModeInfo(ModeInfoSignle(SignMode.signModeDirect)),
          sequence: sequence,
        ),
      ],
      fee: fee,
    );
  }

  /// Reference: https://github.com/cosmos/cosmjs/blob/main/packages/stargate/src/fee.ts
  Fee _calculateFee(
    String gasPriceStr,
    mantra.Simulate200ResponseGasInfo gasInfo,
  ) {
    final gasPrice = double.parse(gasPriceStr);
    final gasLimit = double.parse(gasInfo.gasUsed ?? "30000") * 1.5;

    final gasAmount = gasPrice * gasLimit;

    return Fee(
      amount: [Coin(denom: feeDenom, amount: BigInt.parse(gasAmount.toStringAsFixed(0)))],
      gasLimit: BigInt.parse(gasLimit.toStringAsFixed(0)),
    );
  }
}
