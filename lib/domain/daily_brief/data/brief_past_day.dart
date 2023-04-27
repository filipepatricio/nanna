class BriefPastDay {
  const BriefPastDay(this.date, this.hasBrief);

  factory BriefPastDay.empty(DateTime date) => BriefPastDay(date, false);

  final DateTime date;
  final bool hasBrief;
}
