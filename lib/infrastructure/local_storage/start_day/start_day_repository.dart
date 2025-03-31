import "package:hnotes/domain/count_day/count_day_model.dart";
import "package:hnotes/infrastructure/local_storage/shared_preferences.dart";

class StartDayRepository {
  static final String _startDateSharedPrefKey = "startDate";

  /// Get saved love start date API
  Future<CountDayModel> getLoveStartDate() async {
    String? storedDate = await getDataFromSharedPref(_startDateSharedPrefKey);

    CountDayModel countDayModel = CountDayModel.fromAttribute(storedDate);

    return countDayModel;
  }

  Future<void> saveStartDate(String? selectedDate) async {
    if (selectedDate != null) {
      await setDataInSharedPref(_startDateSharedPrefKey, selectedDate);
    }
  }
}
