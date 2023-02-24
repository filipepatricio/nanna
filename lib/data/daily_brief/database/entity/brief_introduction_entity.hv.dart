import 'package:better_informed_mobile/data/hive_types.dart';
import 'package:hive/hive.dart';

part 'brief_introduction_entity.hv.g.dart';

@HiveType(typeId: HiveTypes.briefIntroductionEntity)
class BriefIntroductionEntity {
  BriefIntroductionEntity({
    required this.text,
    required this.icon,
  });

  @HiveField(0)
  final String text;
  @HiveField(1)
  final String icon;
}
