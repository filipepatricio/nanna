import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

class BriefEntryStyle {
  const BriefEntryStyle({
    required this.backgroundColor,
    required this.type,
  });

  final Color? backgroundColor;
  final BriefEntryStyleType type;
}

enum BriefEntryStyleType {
  @JsonValue('ARTICLE_CARD')
  articleCardLarge,
  @JsonValue('SMALL_ARTICLE_ITEM')
  articleCardMedium,
  @JsonValue('TOPIC_CARD')
  topicCard
}
