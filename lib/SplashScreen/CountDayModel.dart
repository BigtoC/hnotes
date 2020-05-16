class CountDayModel {

  static final startDate = DateTime(2019, DateTime.august, 31);
  static final today = DateTime.now();
  static final daysSince = today.difference(startDate).inDays;

  int get days => daysSince;
}