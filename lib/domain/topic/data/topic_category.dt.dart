import 'package:json_annotation/json_annotation.dart';

part 'topic_category.dt.g.dart';

@JsonSerializable()
class TopicCategory {
  final String name;

  TopicCategory({required this.name});

  factory TopicCategory.fromJson(Map<String, dynamic> json) => _$TopicCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$TopicCategoryToJson(this);
}
