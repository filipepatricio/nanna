import 'package:better_informed_mobile/data/hive_types.dart';
import 'package:hive/hive.dart';

part 'entry_style_type_entity.hv.g.dart';

@HiveType(typeId: HiveTypes.entryStyleTypeEntity)
class EntryStyleTypeEntity {
  EntryStyleTypeEntity({
    required this.name,
  });

  @HiveField(0)
  final String name;
}
