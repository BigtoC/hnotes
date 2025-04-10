import "package:hnotes/infrastructure/local_storage/secrets/secrets_repository.dart";
import "package:rxdart/rxdart.dart";

class WalletBloc {
  final _secretsRepository = SecretsRepository();

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

  void dispose() {
    _walletPrivateKey.close();
    _walletAddress.close();
  }
}

final walletBloc = WalletBloc();
