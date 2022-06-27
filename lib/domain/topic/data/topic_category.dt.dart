import 'package:json_annotation/json_annotation.dart';

part 'topic_category.dt.g.dart';

@JsonSerializable()
class TopicCategory {
  TopicCategory({required this.name});

  factory TopicCategory.fromJson(Map<String, dynamic> json) => _$TopicCategoryFromJson(json);
  final String name;

  Map<String, dynamic> toJson() => _$TopicCategoryToJson(this);
}
