import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_subsection.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'brief_section.dt.freezed.dart';

@freezed
class BriefSection with _$BriefSection {
  const factory BriefSection.entries({
    required String title,
    required Color? backgroundColor,
    required List<BriefEntry> entries,
  }) = BriefSectionWithEntries;

  const factory BriefSection.subsections({
    required String title,
    required Color? backgroundColor,
    required List<BriefSubsection> subsections,
  }) = _BriefSectionWithSubsections;

  const factory BriefSection.unknown() = _BriefSectionUnknown;
}
