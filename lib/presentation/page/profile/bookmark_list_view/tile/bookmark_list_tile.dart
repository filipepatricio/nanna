import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/explore/article_with_cover_area/article_list_item.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/bookmark_button/bookmark_button.dart';
import 'package:better_informed_mobile/presentation/widget/reading_list_cover_small.dart';
import 'package:better_informed_mobile/presentation/widget/share/article_button/share_article_button.dart';
import 'package:better_informed_mobile/presentation/widget/share_button.dart';
import 'package:better_informed_mobile/presentation/widget/stacked_cards/page_view_stacked_card.dart';
import 'package:better_informed_mobile/presentation/widget/stacked_cards/stacked_cards_variant.dart';
import 'package:better_informed_mobile/presentation/widget/updated_label.dart';
import 'package:flutter/material.dart';

const _aspectRatio = 0.64;
const _contentWidthFactor = 0.4;

class BookmarkListTile extends StatelessWidget {
  const BookmarkListTile({
    required this.bookmark,
    Key? key,
  }) : super(key: key);

  final Bookmark bookmark;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.width * _contentWidthFactor / _aspectRatio;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.l,
      ),
      child: Column(
        children: [
          const SizedBox(height: AppDimens.m),
          Container(
            height: height + AppDimens.m,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * _contentWidthFactor,
                      child: AspectRatio(
                        aspectRatio: _aspectRatio,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return bookmark.getContent(
                              context,
                              Size(
                                constraints.maxWidth,
                                constraints.maxHeight,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimens.m),
                  ],
                ),
                const SizedBox(width: AppDimens.m),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        bookmark.title,
                        style: AppTypography.b1Bold,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      ...bookmark.updatedLabel,
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          bookmark.shareButton,
                          const SizedBox(width: AppDimens.m),
                          bookmark.bookmarkButton,
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            color: AppColors.greyDividerColor,
          ),
        ],
      ),
    );
  }
}

extension on Bookmark {
  String get title {
    return data.map(
      article: (data) => data.article.title,
      topic: (data) => data.topic.title,
      unknown: (_) => '',
    );
  }

  List<Widget> get updatedLabel {
    return data.mapOrNull(
          topic: (data) => [
            const SizedBox(height: AppDimens.m),
            UpdatedLabel(
              dateTime: data.topic.lastUpdatedAt,
              backgroundColor: AppColors.transparent,
            ),
          ],
        ) ??
        const [];
  }

  Widget get shareButton {
    return data.map(
      article: (data) => ShareArticleButton(
        backgroundColor: AppColors.transparent,
        article: data.article,
      ),
      topic: (data) => ShareButton(
        onTap: () {},
        backgroundColor: AppColors.transparent,
      ),
      unknown: (_) => const SizedBox(),
    );
  }

  Widget get bookmarkButton {
    return data.map(
      article: (data) => BookmarkButton.article(
        article: data.article,
        mode: BookmarkButtonMode.color,
      ),
      topic: (data) => BookmarkButton.topic(
        topic: data.topic,
        mode: BookmarkButtonMode.color,
      ),
      unknown: (_) => const SizedBox(),
    );
  }

  Widget getContent(BuildContext context, Size size) {
    return data.mapOrNull(
          article: (data) => ArticleListItem(
            article: data.article,
            themeColor: AppColors.background,
            height: size.height,
            width: size.width,
          ),
          topic: (data) => PageViewStackedCards.variant(
            variant: StackedCardsVariant.a,
            coverSize: size,
            child: ReadingListCoverSmall(
              topic: data.topic,
              onTap: () {
                AutoRouter.of(context).push(
                  TopicPage(
                    topicSlug: data.topic.slug,
                    topic: data.topic,
                  ),
                );
              },
            ),
          ),
        ) ??
        SizedBox(
          height: size.height,
          width: size.width,
        );
  }
}
