import 'package:hnotes/domain/common_data.dart';
import 'package:hnotes/domain/count_day/count_day_model.dart';
import 'package:hnotes/infrastructure/local_storage/share_preferences.dart';

class StartDayRepository {
  /// Get saved love start date API
  Future<CountDayModel> getLoveStartDate() async {
    String? storedDate = await getDataFromSharedPref(startDateKey);

    CountDayModel countDayModel = CountDayModel.fromAttribute(storedDate);

    return countDayModel;
  }
}