import 'package:better_informed_mobile/domain/topic/data/topic.dart';

class MyReadsItem {
  final Topic topic;
  final int articlesCount;
  final int finishedArticlesCount;

  MyReadsItem({
    required this.topic,
    required this.articlesCount,
    required this.finishedArticlesCount,
  });
}
