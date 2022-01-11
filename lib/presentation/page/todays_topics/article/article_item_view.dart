import 'package:better_informed_mobile/domain/daily_brief/data/entry.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/entry_style.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/article/covers/colored_cover.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/article/covers/photo_stacked_cover.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/device_type.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ArticleItemView extends HookWidget {
  final int index;
  final double topPadding;
  final Function() onTap;
  final Topic topic;
  final GlobalKey? mediaItemKey;

  ArticleItemView({
    required this.index,
    required this.topPadding,
    required this.onTap,
    required this.topic,
    this.mediaItemKey,
    Key? key,
  })  : assert(topic.readingList.entries[index].item is MediaItemArticle,
            'Article at index $index in reading list must be a MediaItemArticle'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final allEntries = topic.readingList.entries;
    final currentEntry = allEntries[index];
    final article = currentEntry.item as MediaItemArticle;
    final note = currentEntry.note;
    final backgroundColor = currentEntry.style.type == EntryStyleType.articleCoverWithoutImage
        ? AppColors.background
        : currentEntry.style.color;

    return Container(
      color: backgroundColor,
      padding: EdgeInsets.only(
        top: topPadding + AppDimens.s,
        left: AppDimens.l,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ArticleCover(entry: currentEntry, article: article, mediaItemKey: mediaItemKey),
            if (!kIsSmallDevice && note != null) ...[
              const SizedBox(height: AppDimens.m),
              Container(
                padding: const EdgeInsets.only(right: AppDimens.l),
                child: _EditorsNote(introduction: note),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ArticleCover extends StatelessWidget {
  final Entry entry;
  final MediaItemArticle article;
  final GlobalKey? mediaItemKey;

  const _ArticleCover({
    required this.entry,
    required this.article,
    required this.mediaItemKey,
  });

  @override
  Widget build(BuildContext context) {
    switch (entry.style.type) {
      case EntryStyleType.articleCoverWithBigImage:
        return Padding(
          padding: const EdgeInsets.only(right: AppDimens.l),
          child: PhotoStackedCover(
            article: article,
            key: mediaItemKey,
          ),
        );
      case EntryStyleType.articleCoverWithoutImage:
        return Padding(
          padding: const EdgeInsets.only(right: AppDimens.l),
          child: ColoredCover(
            backgroundColor: entry.style.color,
            article: article,
            key: mediaItemKey,
          ),
        );
    }
  }
}

class _EditorsNote extends StatelessWidget {
  final String introduction;

  const _EditorsNote({required this.introduction, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InformedMarkdownBody(
      markdown: introduction,
      baseTextStyle: AppTypography.b2RegularLora,
      maxLines: 5,
    );
  }
}
