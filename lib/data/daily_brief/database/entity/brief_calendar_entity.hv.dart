import 'package:better_informed_mobile/data/hive_types.dart';
import 'package:hive_flutter/adapters.dart';

part 'brief_calendar_entity.hv.g.dart';

@HiveType(typeId: HiveTypes.briefCalendarEntity)
class BriefCalendarEntity {
  BriefCalendarEntity({
    required this.current,
    required this.pastItems,
  });

  @HiveField(0)
  final String current;
  @HiveField(1)
  final List<String> pastItems;
}
