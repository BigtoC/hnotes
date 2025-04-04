import "package:rxdart/rxdart.dart";

import "package:hnotes/infrastructure/blockchain/blockchain_info_repository.dart";

class BlockchainInfoBloc {
  final BlockchainInfoRepository _blockchainInfoRepository =
      BlockchainInfoRepository();

  final _latestBlockData = PublishSubject<Map<String, String>>();
  final _gasPriceData = PublishSubject<Map<String, String>>();
  final _nodeInfoData = PublishSubject<Map<String, String>>();

  Stream<Map<String, String>> get gasPriceStream => _gasPriceData.stream;

  Stream<Map<String, String>> get nodeInfoStream =>
      _nodeInfoData.stream;
  Stream<Map<String, String>> get latestBlockStream =>
      _latestBlockData.stream;

  sinkAllBlockchainInfo() async {
    Future.wait([
      _sinkData(_latestBlockData,
          _blockchainInfoRepository.fetchLatestBlockInfo()),
      _sinkData(_gasPriceData, _blockchainInfoRepository.fetchGasPrice()),
      _sinkData(_nodeInfoData, _blockchainInfoRepository.fetchNodeInfo())
    ]);
  }

  Future<void> _sinkData(PublishSubject data, Future fetchFunction) async {
    data.sink.add(await fetchFunction);
  }

  void dispose() {
    _latestBlockData.close();
    _gasPriceData.close();
    _nodeInfoData.close();
  }
}

final blockchainInfoBloc = BlockchainInfoBloc();
