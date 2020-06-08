import 'package:rxdart/rxdart.dart';

import 'package:hnotes/util/common_data.dart';
import 'package:hnotes/requester/repository.dart';
import 'package:hnotes/splash_screen/count_day_model.dart';

class CountDayBloc {
  final _repository = new Repository();
  final today = DateTime.now();

  final _dayModel = new PublishSubject<CountDayModel>();

  Stream<CountDayModel> get dayModel => _dayModel.stream;

  fetchLoveStartDate() async {
    String loveStartDate = await _repository.fetchLoveStartDate();
    await new Future.delayed(new Duration(milliseconds: 500));

    int daysSince = today.difference(DateTime.parse(loveStartDate)).inDays;

    globalDayCount = daysSince;
    globalLoveStartDate = loveStartDate;

    _dayModel.sink.add(CountDayModel.fromAttribute(loveStartDate, daysSince));
  }

  bool isDispose = false;

  void dispose() {
    _dayModel.close();
  }
}

final daysBloc = new CountDayBloc();
