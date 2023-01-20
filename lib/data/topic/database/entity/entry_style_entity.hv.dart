import 'package:better_informed_mobile/data/hive_types.dart';
import 'package:better_informed_mobile/data/topic/database/entity/entry_style_type_entity.hv.dart';
import 'package:hive/hive.dart';

part 'entry_style_entity.hv.g.dart';

@HiveType(typeId: HiveTypes.entryStyleEntity)
class EntryStyleEntity {
  EntryStyleEntity({
    required this.color,
    required this.type,
  });

  @HiveField(0)
  final int color;
  @HiveField(1)
  final EntryStyleTypeEntity type;
}
