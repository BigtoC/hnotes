import "package:hnotes/infrastructure/blockchain/address_repository.dart";
import "package:mantrachain_dart_sdk/api.dart";
import "package:rxdart/rxdart.dart";

import "package:hnotes/infrastructure/local_storage/secrets/secrets_repository.dart";

class AddressBloc {
  final _secretsRepository = SecretsRepository();
  final _addressRepository = AddressRepository();

  final _walletPrivateKey = PublishSubject<String>();
  final _walletAddress = PublishSubject<String>();
  final _addressAndBalance = PublishSubject<Map<String, String>>();
  final _walletBalances = PublishSubject<List<Coin>>();

  Stream<String> get walletPrivateKeyStream => _walletPrivateKey.stream;

  Stream<String> get walletAddressStream => _walletAddress.stream;

  Stream<Map<String, String>> get addressAndBalanceStream =>
      _addressAndBalance.stream;

  Stream<List<Coin>> get walletBalancesStream => _walletBalances.stream;

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

  getAddressAndBalance() async {
    final addressAndBalance = await _addressRepository.fetchAddressAndBalance();
    _addressAndBalance.sink.add(addressAndBalance);
  }

  getWalletBalances(String address) async {
    _walletBalances.sink.add(
      await _addressRepository.fetchAddressBalances(address),
    );
  }

  void dispose() {
    _walletPrivateKey.close();
    _walletAddress.close();
  }
}

final addressBloc = AddressBloc();
