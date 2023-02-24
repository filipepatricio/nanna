import 'package:better_informed_mobile/data/daily_brief/database/entity/brief_entry_entity.hv.dart';
import 'package:better_informed_mobile/data/hive_types.dart';
import 'package:hive/hive.dart';

part 'brief_subsection_entity.hv.g.dart';

@HiveType(typeId: HiveTypes.briefSubsectionEntity)
class BriefSubsectionEntity {
  BriefSubsectionEntity({
    required this.title,
    required this.entries,
  });

  @HiveField(0)
  final String title;
  @HiveField(1)
  final List<BriefEntryEntity> entries;
}
