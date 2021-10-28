import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/article/data/article.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/entry.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_content_section.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/article/media_item_page_data.dart';
import 'package:better_informed_mobile/presentation/page/explore_tab/article_with_cover_section/article_list_item.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/widget/article_label/article_label.dart';
import 'package:better_informed_mobile/presentation/widget/article_label/exclusive_label.dart';
import 'package:better_informed_mobile/presentation/widget/hero_tag.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/publisher_logo.dart';
import 'package:better_informed_mobile/presentation/widget/read_more_label.dart';
import 'package:better_informed_mobile/presentation/widget/see_all_button.dart';
import 'package:better_informed_mobile/presentation/widget/share_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const _mainArticleHeight = 366.0;
const _mainArticleCoverBottomMargin = 100.0;

class ArticleWithCoverSectionView extends StatelessWidget {
  final ExploreContentSectionArticleWithCover section;

  const ArticleWithCoverSectionView({
    required this.section,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeColor = Color(section.themeColor);

    return Container(
      color: themeColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppDimens.xc),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
            child: Row(
              children: [
                Expanded(
                  child: Hero(
                    // TODO change to some ID or UUID if available
                    tag: HeroTag.exploreArticleTitle(section.title.hashCode),
                    child: InformedMarkdownBody(
                      markdown: section.title,
                      baseTextStyle: AppTypography.h1,
                      highlightColor: AppColors.transparent,
                      maxLines: 2,
                    ),
                  ),
                ),
                const SizedBox(width: AppDimens.s),
                SeeAllButton(
                  onTap: () => AutoRouter.of(context).push(
                    ArticleSeeAllPageRoute(
                      title: section.title,
                      entries: section.entries,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimens.l),
          Container(
            padding: const EdgeInsets.only(left: AppDimens.l),
            height: _mainArticleHeight,
            child: _MainArticle(
              entry: section.coverEntry,
              themeColor: themeColor,
            ),
          ),
          const SizedBox(height: AppDimens.l),
          SizedBox(
            height: listItemHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
              itemBuilder: (context, index) => ArticleListItem(
                entry: section.entries[index],
                themeColor: themeColor,
              ),
              separatorBuilder: (context, index) => const SizedBox(width: AppDimens.s),
              itemCount: section.entries.length,
            ),
          ),
          const SizedBox(height: AppDimens.xxl),
        ],
      ),
    );
  }
}

class _MainArticle extends HookWidget {
  final Entry entry;
  final Color themeColor;

  const _MainArticle({
    required this.entry,
    required this.themeColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cloudinaryProvider = useCloudinaryProvider();
    final imageId = entry.item.image?.publicId;

    return GestureDetector(
      onTap: () => AutoRouter.of(context).push(
        MediaItemPageRoute(
          pageData: MediaItemPageData.singleItem(
            entry: entry,
          ),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) => Stack(
          children: [
            Container(
              height: _mainArticleHeight,
              child: imageId != null
                  ? Image.network(
                      cloudinaryProvider
                          .withPublicId(imageId)
                          .transform()
                          .withLogicalSize(constraints.maxWidth, constraints.maxHeight, context)
                          .autoGravity()
                          .generateNotNull(),
                      fit: BoxFit.cover,
                      alignment: Alignment.bottomLeft,
                    )
                  : Container(),
            ),
            Positioned.fill(
              child: Container(
                color: AppColors.black.withOpacity(0.3),
              ),
            ),
            Positioned(
              top: AppDimens.zero,
              left: AppDimens.zero,
              bottom: _mainArticleCoverBottomMargin,
              right: constraints.maxWidth * 0.45,
              child: _MainArticleCover(
                entry: entry,
                themeColor: themeColor,
              ),
            ),
            Positioned(
              top: AppDimens.l,
              right: AppDimens.l,
              child: ShareButton(onTap: () {}),
            ),
            const Positioned(
              bottom: AppDimens.l,
              right: AppDimens.l,
              child: ReadMoreLabel(
                foregroundColor: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MainArticleCover extends StatelessWidget {
  final Entry entry;
  final Color themeColor;

  const _MainArticleCover({
    required this.entry,
    required this.themeColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.m),
      color: AppColors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: entry.item.type == ArticleType.premium
                ? const ExclusiveLabel()
                : ArticleLabel.opinion(backgroundColor: themeColor),
          ),
          const Spacer(),
          PublisherLogo.light(publisher: entry.item.publisher),
          InformedMarkdownBody(
            markdown: entry.item.title,
            baseTextStyle: AppTypography.h3bold,
            maxLines: 4,
          ),
          const Spacer(),
          Text(
            LocaleKeys.article_readMinutes.tr(
              args: [entry.item.timeToRead.toString()],
            ),
            style: AppTypography.metadata1Regular,
          ),
        ],
      ),
    );
  }
}
