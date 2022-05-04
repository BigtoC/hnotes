import 'package:rxdart/rxdart.dart';

import 'package:hnotes/requester/repository.dart';
import 'package:hnotes/infrastructure/blockchain/dto/dto_collections.dart';

class ChainInfoBloc {
  final Repository _repository = new Repository();
  final _latestBlockNumberData = new PublishSubject<Map<String, dynamic>>();
  final _accountData = new PublishSubject<Map<String, dynamic>>();

  Stream<Map<String, dynamic>> get latestBlockNumberData => _latestBlockNumberData.stream;
  Stream<Map<String, dynamic>> get accountData => _accountData.stream;

  fetchChainInfo() async {
    Map<String, dynamic> latestBlockNumberRaw = await _repository.chainCall().queryLatestBlock();
    _latestBlockNumberData.sink.add(latestBlockNumberRaw);
    // Map<String, dynamic> accountDataRaw = await _repository.chainCall().queryAccount();
    // _accountData.sink.add(accountDataRaw);
  }

  void dispose() {
    _latestBlockNumberData.close();
    _accountData.close();
  }

}

final chainInfoBloc = new ChainInfoBloc();
