import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:flutter/material.dart';

class QuoteAuthor extends StatelessWidget {
  const QuoteAuthor({
    required this.article,
    required this.style,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    if (article.author == null) {
      return Text(
        '${article.publisher.name}',
        style: style,
        maxLines: 1,
      );
    } else {
      return Text(
        '${article.publisher.name} · By ${article.author}',
        style: style,
        maxLines: 1,
      );
    }
  }
}
