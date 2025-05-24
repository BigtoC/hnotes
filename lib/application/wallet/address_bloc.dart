import "package:rxdart/rxdart.dart";
import "dart:async";

import "package:hnotes/domain/blockchain/dtos/address_dto.dart";
import "package:hnotes/infrastructure/blockchain/address_repository.dart";

class AddressBloc {
  final _addressRepository = AddressRepository();

  final _addressAndBalance = PublishSubject<Map<String, String>>();
  final _addressBalances = PublishSubject<List<CoinWithExponent>>();

  // Add error controllers to handle stream errors
  final _addressAndBalanceError = PublishSubject<String>();
  final _addressBalancesError = PublishSubject<String>();

  Stream<Map<String, String>> get addressAndBalanceStream =>
      _addressAndBalance.stream;

  Stream<List<CoinWithExponent>> get walletBalancesStream =>
      _addressBalances.stream;

  // Expose error streams
  Stream<String> get addressAndBalanceErrorStream =>
      _addressAndBalanceError.stream;

  Stream<String> get addressBalancesErrorStream =>
      _addressBalancesError.stream;

  Future<void> getAddressAndBalance() async {
    try {
      final addressAndBalance = await _addressRepository.fetchAddressAndBalance();
      _addressAndBalance.sink.add(addressAndBalance);
    } catch (error, stackTrace) {
      _addressAndBalanceError.sink.add(
          "Failed to fetch address and balance: ${error.toString()}"
      );
    }
  }

  Future<void> getAddressBalances(String address) async {
    try {
      final balances = await _addressRepository.fetchAddressBalances(address);
      _addressBalances.sink.add(balances);
    } catch (error, stackTrace) {
      _addressBalancesError.sink.add(
          "Failed to fetch address balances: ${error.toString()}"
      );
    }
  }

  void dispose() {
    _addressAndBalance.close();
    _addressBalances.close();
    _addressAndBalanceError.close();
    _addressBalancesError.close();
  }
}

final addressBloc = AddressBloc();
