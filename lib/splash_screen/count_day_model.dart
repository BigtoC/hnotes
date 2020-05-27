
class CountDayModel {
  static final startDate = DateTime(2019, DateTime.august, 31);
  static final today = DateTime.now();
  static final daysSince = today.difference(startDate).inDays;
  static String startDateStr = "${startDate.toIso8601String().split("T")[0]}";

  int get days => daysSince;
  String get startStr => startDateStr;
}