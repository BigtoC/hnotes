import 'package:rxdart/rxdart.dart';

import 'package:hnotes/Infrastructure/blockchain/blockchain_repository.dart';

import 'package:hnotes/requester/repository.dart';
import 'package:hnotes/infrastructure/blockchain/dto/dto_collections.dart';

class BlockchainInfoBloc {
  final BlockchainRepository _blockchainRepository = BlockchainRepository();

  final _latestBlockNumberData = new PublishSubject<Map<String, dynamic>>();
  final _accountData = new PublishSubject<Map<String, dynamic>>();

  Stream<Map<String, dynamic>> get latestBlockNumberData => _latestBlockNumberData.stream;
  Stream<Map<String, dynamic>> get accountData => _accountData.stream;

  fetchBlockchainInfo() async {
    _latestBlockNumberData.sink.add(await _blockchainRepository.getLatestBlockNumber());
    // Map<String, dynamic> accountDataRaw = await _repository.chainCall().queryAccount();
    // _accountData.sink.add(accountDataRaw);
  }

  void dispose() {
    _latestBlockNumberData.close();
    _accountData.close();
  }

}

final blockchainInfoBloc = new BlockchainInfoBloc();
