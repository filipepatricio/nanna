import 'package:better_informed_mobile/domain/daily_brief/data/entry_style.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/article/covers/colored_cover.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/article/covers/photo_stacked_cover.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ArticleItemView extends HookWidget {
  final Function() onTap;
  final MediaItemArticle article;
  final EntryStyle entryStyle;
  final String? editorsNote;
  final GlobalKey? mediaItemKey;

  const ArticleItemView({
    required this.onTap,
    required this.article,
    required this.entryStyle,
    this.editorsNote,
    this.mediaItemKey,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimens.topicViewMediaItemMaxHeight(context),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _ArticleCover(
                entryStyle: entryStyle,
                article: article,
                mediaItemKey: mediaItemKey,
                editorsNote: editorsNote,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArticleCover extends StatelessWidget {
  final EntryStyle entryStyle;
  final MediaItemArticle article;
  final GlobalKey? mediaItemKey;
  final String? editorsNote;

  const _ArticleCover({
    required this.entryStyle,
    required this.article,
    required this.mediaItemKey,
    this.editorsNote,
  });

  @override
  Widget build(BuildContext context) {
    switch (entryStyle.type) {
      case EntryStyleType.articleCoverWithBigImage:
        return PhotoStackedCover(
          key: mediaItemKey,
          article: article,
          editorsNote: editorsNote,
        );
      case EntryStyleType.articleCoverWithoutImage:
        return ColoredCover(
          key: mediaItemKey,
          article: article,
          editorsNote: editorsNote,
          backgroundColor: entryStyle.color,
        );
    }
  }
}
