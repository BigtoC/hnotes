import 'package:rxdart/rxdart.dart';

import 'package:hnotes/Infrastructure/blockchain/services/blockchain_repository.dart';

class BlockchainInfoBloc {
  final BlockchainRepository _blockchainRepository = BlockchainRepository();

  final _latestBlockNumberData = new PublishSubject<Map<String, dynamic>>();
  final _currentGasPriceData = new PublishSubject<Map<String, dynamic>>();

  final _currentNetworkData = new PublishSubject<Map<String, dynamic>>();
  final _chainIdData = new PublishSubject<Map<String, dynamic>>();
  final _nodeClientVersionData = new PublishSubject<Map<String, dynamic>>();

  final _accountData = new PublishSubject<Map<String, dynamic>>();

  Stream<Map<String, dynamic>> get latestBlockNumberData => _latestBlockNumberData.stream;
  Stream<Map<String, dynamic>> get currentGasPriceData => _currentGasPriceData.stream;

  Stream<Map<String, dynamic>> get currentNetworkData => _currentNetworkData.stream;
  Stream<Map<String, dynamic>> get chainIdData => _chainIdData.stream;

  Stream<Map<String, dynamic>> get nodeClientVersionData => _nodeClientVersionData.stream;

  Stream<Map<String, dynamic>> get accountData => _accountData.stream;

  fetchBlockchainInfo() async {
    Future.wait([
      _sinkData(_latestBlockNumberData, _blockchainRepository.getLatestBlockNumber()),
      _sinkData(_currentGasPriceData, _blockchainRepository.getCurrentGasPrice()),
      _sinkData(_currentNetworkData, _blockchainRepository.getNetwork()),
      _sinkData(_chainIdData, _blockchainRepository.getChainId()),
      _sinkData(_nodeClientVersionData, _blockchainRepository.getNodeClientVersion())
    ]);
  }

  Future<void> _sinkData(PublishSubject data, Future fetchFunction) async {
    data.sink.add(await fetchFunction);
  }

  void dispose() {
    _latestBlockNumberData.close();
    _currentGasPriceData.close();
    _currentNetworkData.close();
    _chainIdData.close();
    _nodeClientVersionData.close();
    _accountData.close();
  }
}

final blockchainInfoBloc = new BlockchainInfoBloc();
