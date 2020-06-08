
class CountDayModel {
  final String loveStartDate;
  final int dayCount;

  CountDayModel(
    this.loveStartDate,
    this.dayCount
  );

  factory CountDayModel.fromAttribute(String loveDate, int daySince) {
    return new CountDayModel(loveDate, daySince);
  }

}


//class CountDayModel {
//  static final startDate = DateTime(2019, DateTime.august, 31);
//  static final today = DateTime.now();
//  static final daysSince = today.difference(startDate).inDays;
//  static String startDateStr = "${startDate.toIso8601String().split("T")[0]}";
//
//  int get days => daysSince;
//  String get startStr => startDateStr;
//}
