import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

class BriefEntryStyle {
  final Color? backgroundColor;
  final BriefEntryStyleType type;

  const BriefEntryStyle({
    required this.backgroundColor,
    required this.type,
  });
}

enum BriefEntryStyleType {
  @JsonValue('ARTICLE_CARD')
  articleCardWithLargeImage,
  @JsonValue('SMALL_ARTICLE_CARD')
  articleCardWithSmallImage,
  @JsonValue('TOPIC_CARD')
  topicCard
}
