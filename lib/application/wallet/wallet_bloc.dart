import "package:hnotes/infrastructure/blockchain/wallet_repository.dart";
import "package:rxdart/rxdart.dart";

import "package:hnotes/infrastructure/local_storage/secrets/secrets_repository.dart";

class WalletBloc {
  final _secretsRepository = SecretsRepository();
  final _walletRepository = WalletRepository();

  final _walletPrivateKey = PublishSubject<String>();
  final _walletAddress = PublishSubject<String>();
  final _addressAndBalance = PublishSubject<Map<String, String>>();

  Stream<String> get walletPrivateKeyStream => _walletPrivateKey.stream;
  Stream<String> get walletAddressStream => _walletAddress.stream;
  Stream<Map<String, String>> get addressAndBalanceStream =>
      _addressAndBalance.stream;

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
        await _secretsRepository.getImportedWalletAddress()
    );
  }

  getAddressAndBalance() async {
    final addressAndBalance = await _walletRepository.fetchAddressAndBalance();
    _addressAndBalance.sink.add(addressAndBalance);
  }

  void dispose() {
    _walletPrivateKey.close();
    _walletAddress.close();
  }
}

final walletBloc = WalletBloc();
