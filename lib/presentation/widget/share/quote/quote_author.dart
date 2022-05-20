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
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (article.author != null) ...[
          Flexible(
            child: Text(
              article.publisher.name,
              style: style,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            ' . ',
            style: style,
            maxLines: 1,
          ),
        ],
        Text(
          'By ${article.author}',
          style: style,
          maxLines: 1,
        )
      ],
    );
  }
}
