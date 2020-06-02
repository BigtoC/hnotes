import 'package:rxdart/rxdart.dart';

import 'package:hnotes/requester/repository.dart';

class ChainInfoBloc {
  final Repository repository = new Repository();
  final _blockHeaderData = new PublishSubject<Map<String, dynamic>>();


  bool _isDispose = false;
  void dispose() {
    _blockHeaderData.close();

    _isDispose = true;
  }

}

final chainInfoBloc = new ChainInfoBloc();
