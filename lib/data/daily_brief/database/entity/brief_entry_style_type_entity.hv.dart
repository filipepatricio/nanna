import 'package:better_informed_mobile/data/hive_types.dart';
import 'package:hive/hive.dart';

part 'brief_entry_style_type_entity.hv.g.dart';

@HiveType(typeId: HiveTypes.briefEntryStyleTypeEntity)
class BriefEntryStyleTypeEntity {
  BriefEntryStyleTypeEntity(this.name);

  @HiveField(0)
  final String name;
}
