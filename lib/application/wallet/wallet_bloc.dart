import "package:cosmos_sdk/cosmos_sdk.dart";
import "package:hnotes/infrastructure/blockchain/wallet_repository.dart";
import "package:hnotes/infrastructure/local_storage/secrets/secrets_repository.dart";
import "package:rxdart/rxdart.dart";

class WalletBloc {
  final _secretsRepository = SecretsRepository();
  final _walletRepository = WalletRepository();

  final _walletPrivateKey = PublishSubject<String>();
  final _walletAddress = PublishSubject<String>();

  Stream<String> get walletPrivateKeyStream => _walletPrivateKey.stream;

  Stream<String> get walletAddressStream => _walletAddress.stream;

  fetchSecret() async {
    await getImportedWalletAddress();
    await exportPrivateKey();
  }

  exportPrivateKey() async {
    _walletPrivateKey.sink.add(await _secretsRepository.exportPrivateKey());
  }

  Future<String> importPrivateKey(String value) async {
    return await _secretsRepository.deriveAndSaveWallet(value);
  }

  getImportedWalletAddress() async {
    _walletAddress.sink.add(
      await _secretsRepository.getImportedWalletAddress(),
    );
  }

  sendToken(String sender, BigInt amount, String denom, String receiver) {
    final message = MsgSend(
        fromAddress: CosmosBaseAddress(sender),
        toAddress:
        CosmosBaseAddress(receiver),
        amount: [Coin(denom: denom, amount: amount)]
    );
    final txHash = _walletRepository.signAndBroadcast(sender, [message]);
  }

  void dispose() {
    _walletPrivateKey.close();
    _walletAddress.close();
  }
}

final walletBloc = WalletBloc();
