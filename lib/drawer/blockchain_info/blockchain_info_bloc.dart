import 'package:rxdart/rxdart.dart';

import 'package:hnotes/Infrastructure/blockchain/blockchain_repository.dart';

class BlockchainInfoBloc {
  final BlockchainRepository _blockchainRepository = BlockchainRepository();

  final _latestBlockNumberData = new PublishSubject<Map<String, dynamic>>();
  final _currentGasPriceData = new PublishSubject<Map<String, dynamic>>();
  final _accountData = new PublishSubject<Map<String, dynamic>>();

  Stream<Map<String, dynamic>> get latestBlockNumberData => _latestBlockNumberData.stream;
  Stream<Map<String, dynamic>> get accountData => _accountData.stream;
  Stream<Map<String, dynamic>> get currentGasPriceData => _currentGasPriceData.stream;


  fetchBlockchainInfo() async {
    _latestBlockNumberData.sink.add(await _blockchainRepository.getLatestBlockNumber());
    _currentGasPriceData.sink.add(await _blockchainRepository.getCurrentGasPrice());
  }

  void dispose() {
    _latestBlockNumberData.close();
    _currentGasPriceData.close();
    _accountData.close();
  }
}

final blockchainInfoBloc = new BlockchainInfoBloc();
