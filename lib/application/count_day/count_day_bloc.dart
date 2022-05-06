import 'package:rxdart/rxdart.dart';

import 'package:hnotes/domain/common_data.dart';
import 'package:hnotes/domain/count_day/count_day_model.dart';
import 'package:hnotes/infrastructure/local_storage/start_day/start_day_repository.dart';

class CountDayBloc {
  final _repository = new StartDayRepository();
  final today = DateTime.now();

  final _dayModel = new PublishSubject<CountDayModel>();

  Stream<CountDayModel> get dayModel => _dayModel.stream;

  fetchLoveStartDate() async {
    String? loveStartDate = await _repository.getLoveStartDate();

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
