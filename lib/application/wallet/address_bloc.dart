import "package:rxdart/rxdart.dart";

import "package:hnotes/domain/blockchain/dtos/address_dto.dart";
import "package:hnotes/infrastructure/blockchain/address_repository.dart";

class AddressBloc {
  final _addressRepository = AddressRepository();

  final _addressAndBalance = PublishSubject<Map<String, String>>();
  final _addressBalances = PublishSubject<List<CoinWithExponent>>();

  Stream<Map<String, String>> get addressAndBalanceStream =>
      _addressAndBalance.stream;

  Stream<List<CoinWithExponent>> get walletBalancesStream =>
      _addressBalances.stream;

  getAddressAndBalance() async {
    final addressAndBalance = await _addressRepository.fetchAddressAndBalance();
    _addressAndBalance.sink.add(addressAndBalance);
  }

  getAddressBalances(String address) async {
    _addressBalances.sink.add(
      await _addressRepository.fetchAddressBalances(address),
    );
  }

  void dispose() {
    _addressAndBalance.close();
    _addressBalances.close();
  }
}

final addressBloc = AddressBloc();
