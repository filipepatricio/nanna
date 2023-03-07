import 'package:better_informed_mobile/data/daily_brief/database/entity/brief_entry_style_type_entity.hv.dart';
import 'package:better_informed_mobile/data/hive_types.dart';
import 'package:hive/hive.dart';

part 'brief_entry_style_entity.hv.g.dart';

@HiveType(typeId: HiveTypes.briefEntryStyleEntity)
class BriefEntryStyleEntity {
  BriefEntryStyleEntity({
    required this.color,
    required this.type,
  });

  @HiveField(0)
  final int? color;
  @HiveField(1)
  final BriefEntryStyleTypeEntity type;
}
