import 'package:better_informed_mobile/data/article/database/entity/curator_entity.hv.dart';
import 'package:better_informed_mobile/data/hive_types.dart';
import 'package:hive/hive.dart';

part 'curation_info_entity.hv.g.dart';

@HiveType(typeId: HiveTypes.curationInfoEntity)
class CurationInfoEntity {
  CurationInfoEntity({
    required this.byline,
    required this.curator,
  });

  @HiveField(0)
  final String byline;
  @HiveField(1)
  final CuratorEntity curator;
}
