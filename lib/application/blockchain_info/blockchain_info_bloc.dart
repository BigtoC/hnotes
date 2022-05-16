import 'package:rxdart/rxdart.dart';

import 'package:hnotes/infrastructure/blockchain/blockchain_info_repository.dart';


class BlockchainInfoBloc {
  final BlockchainInfoRepository _blockchainInfoRepository = BlockchainInfoRepository();

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

  fetchAllBlockchainInfo() async {
    Future.wait([
      _sinkData(_latestBlockNumberData, _blockchainInfoRepository.getLatestBlockNumber()),
      _sinkData(_currentGasPriceData, _blockchainInfoRepository.getCurrentGasPrice()),
      _sinkData(_currentNetworkData, _blockchainInfoRepository.getNetwork()),
      _sinkData(_chainIdData, _blockchainInfoRepository.getChainId()),
      _sinkData(_nodeClientVersionData, _blockchainInfoRepository.getNodeClientVersion())
    ]);
  }

  fetchNetworkData() async {
    await _sinkData(_currentNetworkData, _blockchainInfoRepository.getNetwork());
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
