import 'package:freezed_annotation/freezed_annotation.dart';

part 'brief_calendar.dt.freezed.dart';

@Freezed(toJson: false)
class BriefCalendar with _$BriefCalendar {
  factory BriefCalendar({
    required DateTime current,
    required List<DateTime> pastItems,
  }) = _BriefCalendar;
}
