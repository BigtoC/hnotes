import "package:rxdart/rxdart.dart";

import "package:hnotes/infrastructure/blockchain/blockchain_info_repository.dart";

class BlockchainInfoBloc {
  final BlockchainInfoRepository _blockchainInfoRepository =
      BlockchainInfoRepository();

  final _latestBlockNumberData = PublishSubject<Map<String, dynamic>>();
  final _currentGasPriceData = PublishSubject<Map<String, dynamic>>();

  final _currentNetworkData = PublishSubject<Map<String, dynamic>>();
  final _chainIdData = PublishSubject<Map<String, dynamic>>();
  final _nodeClientVersionData = PublishSubject<Map<String, dynamic>>();

  final _accountData = PublishSubject<Map<String, dynamic>>();

  Stream<Map<String, dynamic>> get latestBlockNumberData =>
      _latestBlockNumberData.stream;

  Stream<Map<String, dynamic>> get currentGasPriceData =>
      _currentGasPriceData.stream;

  Stream<Map<String, dynamic>> get currentNetworkData =>
      _currentNetworkData.stream;

  Stream<Map<String, dynamic>> get chainIdData => _chainIdData.stream;

  Stream<Map<String, dynamic>> get nodeClientVersionData =>
      _nodeClientVersionData.stream;

  Stream<Map<String, dynamic>> get accountData => _accountData.stream;

  fetchAllBlockchainInfo() async {
    Future.wait([
      _sinkData(
        _latestBlockNumberData,
        _blockchainInfoRepository.getLatestBlockNumber(),
      ),
      _sinkData(
        _currentGasPriceData,
        _blockchainInfoRepository.getCurrentGasPrice(),
      ),
      _sinkData(_currentNetworkData, _blockchainInfoRepository.getNetwork()),
      _sinkData(_chainIdData, _blockchainInfoRepository.getChainId()),
      _sinkData(
        _nodeClientVersionData,
        _blockchainInfoRepository.getNodeClientVersion(),
      ),
    ]);
  }

  Future<Map<String, dynamic>> fetchNetworkData() async {
    Future<Map<String, dynamic>> network =
        _blockchainInfoRepository.getNetwork();
    await _sinkData(_currentNetworkData, network);
    return await network;
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

final blockchainInfoBloc = BlockchainInfoBloc();
