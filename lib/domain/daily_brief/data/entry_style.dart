import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

class EntryStyle {
  const EntryStyle({
    required this.color,
    required this.type,
  });
  final Color color;
  final EntryStyleType type;
}

enum EntryStyleType {
  @JsonValue('ARTICLE_COVER_WITH_BIG_IMAGE')
  articleCoverWithBigImage,
  @JsonValue('ARTICLE_COVER_WITHOUT_IMAGE')
  articleCoverWithoutImage,
}
