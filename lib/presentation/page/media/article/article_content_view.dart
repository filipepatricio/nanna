import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ArticleContentView extends HookWidget {
  final MediaItemArticle article;

  const ArticleContentView({
    required this.article,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
