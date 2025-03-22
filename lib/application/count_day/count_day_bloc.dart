import 'package:rxdart/rxdart.dart';

import 'package:hnotes/domain/common_data.dart';
import 'package:hnotes/domain/count_day/count_day_model.dart';
import 'package:hnotes/infrastructure/local_storage/start_day/start_day_repository.dart';

class CountDayBloc {
  final _repository = StartDayRepository();
  final today = DateTime.now();

  final _dayModel = PublishSubject<CountDayModel>();

  Stream<CountDayModel> get dayModel => _dayModel.stream;

  fetchLoveStartDate() async {
    CountDayModel countDayModel = await _repository.getLoveStartDate();

    globalDayCount = countDayModel.dayCount;

    _dayModel.sink.add(countDayModel);
  }

  Future<void> updateLoveStartDate(String selectedDate) async {
    // Write the selected date to system
    await _repository.saveStartDate(selectedDate);
    // Update the stream data
    await daysBloc.fetchLoveStartDate();
  }

  bool isDispose = false;

  void dispose() {
    _dayModel.close();
  }
}

final daysBloc = CountDayBloc();
