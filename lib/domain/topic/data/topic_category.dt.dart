import 'package:json_annotation/json_annotation.dart';

part 'topic_category.dt.g.dart';

@JsonSerializable(createToJson: false)
class TopicCategory {
  TopicCategory({required this.name});

  factory TopicCategory.fromJson(Map<String, dynamic> json) => _$TopicCategoryFromJson(json);
  final String name;
}
