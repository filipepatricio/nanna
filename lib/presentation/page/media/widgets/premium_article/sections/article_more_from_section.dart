import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/article_cover/article_cover.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/topic_cover.dart';
import 'package:flutter/material.dart';

class ArticleMoreFromSection extends StatelessWidget {
  const ArticleMoreFromSection({
    required this.title,
    required this.items,
    Key? key,
  }) : super(key: key);

  final String title;
  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppDimens.l,
            horizontal: AppDimens.pageHorizontalMargin,
          ),
          child: Text(
            title,
            style: AppTypography.h1Medium,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.m),
          child: Column(
            children: items
                .expand(
                  (element) => [
                    element,
                    if (items.last != element) const Divider(height: AppDimens.xl),
                  ],
                )
                .toList(),
          ),
        ),
        const SizedBox(height: AppDimens.l),
      ],
    );
  }
}

enum MoreFromSectionItemType { article, topic }

class MoreFromSectionListItem extends StatelessWidget {
  const MoreFromSectionListItem._({
    required this.type,
    required this.child,
    Key? key,
  }) : super(key: key);

  factory MoreFromSectionListItem.article({
    required MediaItemArticle article,
    required VoidCallback onItemTap,
  }) =>
      MoreFromSectionListItem._(
        type: MoreFromSectionItemType.article,
        child: ArticleCover.list(
          article: article,
          onTap: onItemTap,
        ),
      );

  factory MoreFromSectionListItem.topic({
    required TopicPreview topic,
    required VoidCallback onItemTap,
  }) =>
      MoreFromSectionListItem._(
        type: MoreFromSectionItemType.topic,
        child: TopicCover.list(
          topic: topic,
          onTap: onItemTap,
        ),
      );

  final MoreFromSectionItemType type;
  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}
