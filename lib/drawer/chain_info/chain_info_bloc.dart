import 'package:rxdart/rxdart.dart';

import 'package:hnotes/requester/repository.dart';

class ChainInfoBloc {
  final Repository _repository = new Repository();
  final _blockHeaderData = new PublishSubject<Map<String, dynamic>>();
  final _accountData = new PublishSubject<Map<String, dynamic>>();

  Stream<Map<String, dynamic>> get blockHeaderData => _blockHeaderData.stream;
  Stream<Map<String, dynamic>> get accountData => _accountData.stream;

  fetchChainInfo() async {
    Map<String, dynamic> blockHeaderRaw = await _repository.chainCall().queryLatestBlock();
    _blockHeaderData.sink.add(blockHeaderRaw);
    Map<String, dynamic> accountDataRaw = await _repository.chainCall().queryAccount();
    _accountData.sink.add(accountDataRaw);
  }

  bool _isDispose = false;

  void dispose() {
    _blockHeaderData.close();
    _accountData.close();
    _isDispose = true;
  }

}

final chainInfoBloc = new ChainInfoBloc();
