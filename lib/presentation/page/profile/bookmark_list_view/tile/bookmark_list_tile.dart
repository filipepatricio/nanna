import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/profile/bookmark_list_view/tile/bookmark_tile_cover.dt.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/article_list_item.dart';
import 'package:better_informed_mobile/presentation/widget/informed_divider.dart';
import 'package:better_informed_mobile/presentation/widget/share/article_button/share_article_button.dart';
import 'package:better_informed_mobile/presentation/widget/share/topic_articles_select_view.dart';
import 'package:better_informed_mobile/presentation/widget/share_button.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/stacked_cards/stacked_cards.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/stacked_cards/stacked_cards_variant.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/topic_cover.dart';
import 'package:better_informed_mobile/presentation/widget/updated_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const _aspectRatio = 0.64;
const _contentWidthFactor = 0.4;

typedef OnRemoveBookmarkPressed = void Function(Bookmark bookmark);

class BookmarkListTile extends StatelessWidget {
  const BookmarkListTile({
    required this.bookmarkCover,
    required this.onRemoveBookmarkPressed,
    Key? key,
  }) : super(key: key);

  final BookmarkTileCover bookmarkCover;
  final OnRemoveBookmarkPressed onRemoveBookmarkPressed;

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
          SizedBox(
            height: height + AppDimens.m,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * _contentWidthFactor,
                      child: AspectRatio(
                        aspectRatio: _aspectRatio,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return bookmarkCover.getContent(
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
                        bookmarkCover.bookmark.title,
                        style: AppTypography.b2Bold,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      ...bookmarkCover.bookmark.updatedLabel,
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          bookmarkCover.bookmark.getShareButton(context),
                          const SizedBox(width: AppDimens.m),
                          _BookmarkRemoveButton(
                            onRemoveBookmarkPressed: () => onRemoveBookmarkPressed(
                              bookmarkCover.bookmark,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const InformedDivider(),
        ],
      ),
    );
  }
}

class _BookmarkRemoveButton extends StatelessWidget {
  const _BookmarkRemoveButton({
    required this.onRemoveBookmarkPressed,
    Key? key,
  }) : super(key: key);

  final VoidCallback onRemoveBookmarkPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onRemoveBookmarkPressed,
      child: SizedBox.square(
        dimension: AppDimens.bookmarkIconSize,
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.xs),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 100),
              child: SvgPicture.asset(AppVectorGraphics.heartSelected),
            ),
          ),
        ),
      ),
    );
  }
}

extension on Bookmark {
  String get title {
    return data.map(
      article: (data) => data.article.strippedTitle,
      topic: (data) => data.topic.strippedTitle,
      unknown: (_) => '',
    );
  }

  List<Widget> get updatedLabel {
    return data.mapOrNull(
          topic: (data) => [
            const SizedBox(height: AppDimens.m),
            UpdatedLabel(
              dateTime: data.topic.lastUpdatedAt,
              fontSize: 10,
              textStyle: AppTypography.subH2Bold.copyWith(
                color: AppColors.textGrey,
                letterSpacing: 1,
              ),
            ),
          ],
        ) ??
        const [];
  }

  Widget getShareButton(BuildContext context) {
    return data.map(
      article: (data) => ShareArticleButton(
        backgroundColor: AppColors.transparent,
        article: data.article,
      ),
      topic: (data) => ShareButton(
        onTap: () => shareTopicArticlesList(context, data.topic),
        backgroundColor: AppColors.transparent,
      ),
      unknown: (_) => const SizedBox.shrink(),
    );
  }
}

extension on BookmarkTileCover {
  Widget getContent(BuildContext context, Size size) {
    return map(
      standard: (_) {
        return bookmark.data.mapOrNull(
              article: (data) => ArticleListItem(
                article: data.article,
                themeColor: AppColors.background,
                height: size.height,
                width: size.width,
              ),
              topic: (_) => throw Exception('There should not be topic with static cover'),
            ) ??
            const SizedBox.shrink();
      },
      dynamic: (cover) {
        return _createDynamicCover(
              context,
              size,
              cover.indexOfType,
              bookmark,
            ) ??
            const SizedBox.shrink();
      },
    );
  }

  Widget? _createDynamicCover(
    BuildContext context,
    Size size,
    int index,
    Bookmark bookmark,
  ) {
    return bookmark.data.mapOrNull(
      article: (data) => ArticleListItem(
        article: data.article,
        themeColor: AppColors.background,
        cardColor: AppColors.mockedColors[index % AppColors.mockedColors.length],
        height: size.height,
        width: size.width,
      ),
      topic: (data) => StackedCards.variant(
        variant: StackedCardsVariant.values[index % StackedCardsVariant.values.length],
        coverSize: size,
        child: TopicCover.small(
          topic: data.topic.asPreview,
          onTap: () => AutoRouter.of(context).push(
            TopicPage(
              topicSlug: data.topic.slug,
            ),
          ),
        ),
      ),
    );
  }
}
