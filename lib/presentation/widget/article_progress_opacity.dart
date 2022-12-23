import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:flutter/material.dart';

class ArticleProgressOpacity extends StatelessWidget {
  const ArticleProgressOpacity({
    required this.article,
    required this.child,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: article.finished ? 0.4 : 1,
      child: child,
    );
  }
}
