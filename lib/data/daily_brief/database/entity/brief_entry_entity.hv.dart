import 'package:better_informed_mobile/data/daily_brief/database/entity/brief_entry_item_entity.hv.dart';
import 'package:better_informed_mobile/data/daily_brief/database/entity/brief_entry_style_entity.hv.dart';
import 'package:better_informed_mobile/data/hive_types.dart';
import 'package:hive/hive.dart';

part 'brief_entry_entity.hv.g.dart';

@HiveType(typeId: HiveTypes.briefEntryEntity)
class BriefEntryEntity {
  BriefEntryEntity({
    required this.item,
    required this.style,
    required this.isNew,
  });

  @HiveField(0)
  final BriefEntryItemEntity item;
  @HiveField(1)
  final BriefEntryStyleEntity style;
  @HiveField(2)
  final bool isNew;
}
