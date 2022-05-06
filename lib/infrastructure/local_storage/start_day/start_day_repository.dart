import 'package:hnotes/infrastructure/local_storage/share_preferences.dart';

class StartDayRepository {
  /// Get saved love start date API
  Future<String> getLoveStartDate() async {
    String theDate = await getDataFromSharedPref('startDate');
    return theDate;
  }
}