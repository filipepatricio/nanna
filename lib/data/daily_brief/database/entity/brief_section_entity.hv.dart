import 'package:better_informed_mobile/data/daily_brief/database/entity/brief_entry_entity.hv.dart';
import 'package:better_informed_mobile/data/daily_brief/database/entity/brief_subsection_entity.hv.dart';
import 'package:better_informed_mobile/data/hive_types.dart';
import 'package:hive/hive.dart';

part 'brief_section_entity.hv.g.dart';

@HiveType(typeId: HiveTypes.briefSectionEntity)
class BriefSectionEntity {
  const BriefSectionEntity(this.entries, this.subsections, this.unknown);

  BriefSectionEntity.entries(BriefSectionEntriesEntity entries) : this(entries, null, null);

  BriefSectionEntity.subsections(BriefSectionSubsectionEntity subsections) : this(null, subsections, null);

  const BriefSectionEntity.unknown() : this(null, null, const BriefSectionUnknownEntity());

  @HiveField(0)
  final BriefSectionEntriesEntity? entries;
  @HiveField(1)
  final BriefSectionSubsectionEntity? subsections;
  @HiveField(2)
  final BriefSectionUnknownEntity? unknown;

  T map<T>({
    required T Function(BriefSectionEntriesEntity) entries,
    required T Function(BriefSectionSubsectionEntity) subsections,
    required T Function(BriefSectionUnknownEntity) unknown,
  }) {
    if (this.entries != null) {
      return entries(this.entries!);
    } else if (this.subsections != null) {
      return subsections(this.subsections!);
    } else if (this.unknown != null) {
      return unknown(this.unknown!);
    } else {
      throw Exception('Unknown type');
    }
  }
}

@HiveType(typeId: HiveTypes.briefSectionEntriesEntity)
class BriefSectionEntriesEntity {
  BriefSectionEntriesEntity({
    required this.title,
    required this.backgroundColor,
    required this.entries,
  });

  @HiveField(0)
  final String title;
  @HiveField(1)
  final int? backgroundColor;
  @HiveField(2)
  final List<BriefEntryEntity> entries;
}

@HiveType(typeId: HiveTypes.briefSectionSubsectionEntity)
class BriefSectionSubsectionEntity {
  BriefSectionSubsectionEntity({
    required this.title,
    required this.backgroundColor,
    required this.subsections,
  });

  @HiveField(0)
  final String title;
  @HiveField(1)
  final int? backgroundColor;
  @HiveField(2)
  final List<BriefSubsectionEntity> subsections;
}

@HiveType(typeId: HiveTypes.briefSectionUnknownEntity)
class BriefSectionUnknownEntity {
  const BriefSectionUnknownEntity();
}
