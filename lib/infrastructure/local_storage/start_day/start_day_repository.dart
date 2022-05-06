import 'package:hnotes/domain/common_data.dart';
import 'package:hnotes/infrastructure/local_storage/share_preferences.dart';

class StartDayRepository {
  /// Get saved love start date API
  Future<String> getLoveStartDate() async {
    String? storedDate = await getDataFromSharedPref(startDateKey);
    String rtnDate = storedDate == null? "" : storedDate;
    globalLoveStartDate = rtnDate;
    return rtnDate;
  }
}