
class CountDayModel {
  final String loveStartDate;
  final int dayCount;

  CountDayModel(
    this.loveStartDate,
    this.dayCount
  );

  factory CountDayModel.fromAttribute(String? loveStartDateParam) {
    String rtnLoveDate = "";
    int rtnDayCount = 0;

    if (loveStartDateParam != null) {
      final today = DateTime.now();
      rtnLoveDate = loveStartDateParam;
      rtnDayCount = today.difference(DateTime.parse(loveStartDateParam)).inDays;
    }

    return new CountDayModel(rtnLoveDate, rtnDayCount);
  }

}
