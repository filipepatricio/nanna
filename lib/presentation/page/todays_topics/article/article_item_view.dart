import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/entry.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/entry_style.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/media/media_item_page.dart';
import 'package:better_informed_mobile/presentation/page/media/media_item_page_data.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/article/covers/colored_cover.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/article/covers/photo_cover.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/article/covers/photo_stacked_cover.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/read_more_label.dart';
import 'package:better_informed_mobile/presentation/widget/share/article_button/share_article_button.dart';
import 'package:better_informed_mobile/presentation/widget/topic_introduction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ArticleItemView extends HookWidget {
  final int index;
  final double statusBarHeight;
  final MediaItemNavigationCallback navigationCallback;
  final Topic topic;
  final GlobalKey? mediaItemKey;

  ArticleItemView({
    required this.index,
    required this.statusBarHeight,
    required this.navigationCallback,
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
    return Container(
      color: currentEntry.style.type == EntryStyleType.articleCoverWithoutImage
          ? AppColors.background
          : currentEntry.style.color,
      padding: EdgeInsets.only(
        top: statusBarHeight,
        bottom: AppDimens.m,
        left: _calculateIndicatorWidth(),
      ),
      child: GestureDetector(
        onTap: () {
          AutoRouter.of(context).push(
            MediaItemPageRoute(
              pageData: MediaItemPageData.multipleItems(
                index: index,
                topic: topic,
                navigationCallback: navigationCallback,
              ),
            ),
          );
        },
        child: Column(
          key: mediaItemKey,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: AppDimens.l, right: AppDimens.xxl),
              child: Row(
                children: [
                  Text('${index + 1}', style: AppTypography.subH1Bold),
                  Text('/${allEntries.length} articles', style: AppTypography.subH1Regular),
                ],
              ),
            ),
            if (currentEntry.note != null) ...[
              const SizedBox(height: AppDimens.m),
              Padding(
                padding: const EdgeInsets.only(right: AppDimens.xxl),
                child: TopicIntroduction(introduction: currentEntry.note!),
              ),
            ],
            const SizedBox(height: AppDimens.l),
            _ArticleCover(entry: currentEntry, article: article),
            const SizedBox(height: AppDimens.xl),
            Padding(
              padding: const EdgeInsets.only(right: AppDimens.l),
              child: Container(
                width: AppDimens.articleItemWidth,
                child: Row(
                  children: [
                    ShareArticleButton(article: article),
                    const Spacer(),
                    const ReadMoreLabel(fontSize: AppDimens.m),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _calculateIndicatorWidth() => AppDimens.l * 2 + AppDimens.verticalIndicatorWidth;
}

class _ArticleCover extends StatelessWidget {
  const _ArticleCover({required this.entry, required this.article});

  final Entry entry;
  final MediaItemArticle article;

  @override
  Widget build(BuildContext context) {
    switch (entry.style.type) {
      case EntryStyleType.articleCoverWithBigImage:
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: AppDimens.l),
            child: PhotoStackedCover(article: article),
          ),
        );
      case EntryStyleType.articleCoverWithSmallImage:
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: AppDimens.m),
            child: PhotoCover(article: article),
          ),
        );
      case EntryStyleType.articleCoverWithoutImage:
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: AppDimens.l),
            child: ColoredCover(backgroundColor: entry.style.color, article: article),
          ),
        );
    }
  }
}
