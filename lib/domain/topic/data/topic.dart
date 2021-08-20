import 'package:better_informed_mobile/domain/daily_brief/data/category.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/image.dart';

class Topic {
  final String id;
  final String title;
  final String introduction;
  final String summary;
  final Category category;
  final Image image;

  Topic({
    required this.id,
    required this.title,
    required this.introduction,
    required this.summary,
    required this.category,
    required this.image,
  });
}
