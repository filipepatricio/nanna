import 'package:better_informed_mobile/data/daily_brief/database/entity/brief_introduction_entity.hv.dart';
import 'package:better_informed_mobile/data/daily_brief/database/entity/brief_section_entity.hv.dart';
import 'package:better_informed_mobile/data/daily_brief/database/entity/headline_entity.hv.dart';
import 'package:better_informed_mobile/data/daily_brief/database/entity/relax_entity.hv.dart';
import 'package:better_informed_mobile/data/hive_types.dart';
import 'package:hive/hive.dart';

part 'brief_entity.hv.g.dart';

@HiveType(typeId: HiveTypes.briefEntity)
class BriefEntity {
  BriefEntity({
    required this.id,
    required this.unseenCount,
    required this.date,
    required this.greeting,
    required this.introduction,
    required this.relax,
    required this.sections,
  });

  @HiveField(0)
  final String id;
  @HiveField(1)
  final int unseenCount;
  @HiveField(2)
  final String date;
  @HiveField(3)
  final HeadlineEntity greeting;
  @HiveField(4)
  final BriefIntroductionEntity? introduction;
  @HiveField(5)
  final RelaxEntity relax;
  @HiveField(6)
  final List<BriefSectionEntity> sections;
}
