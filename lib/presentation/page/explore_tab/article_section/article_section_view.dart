import 'package:better_informed_mobile/domain/article/data/article.dart';
import 'package:better_informed_mobile/domain/article/data/article_header.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_content_section.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/article/article_page.dart';
import 'package:better_informed_mobile/presentation/page/explore_tab/article_section/article_list_item.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/util/dimension_util.dart';
import 'package:better_informed_mobile/presentation/widget/article_label/article_label.dart';
import 'package:better_informed_mobile/presentation/widget/article_label/exclusive_label.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/read_more_label.dart';
import 'package:better_informed_mobile/presentation/widget/see_all_button.dart';
import 'package:better_informed_mobile/presentation/widget/share_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

const _mainArticleHeight = 366.0;
const _mainArticleCoverBottomMargin = 100.0;
const _publisherLogoSize = 24.0;

class ArticleSectionView extends StatelessWidget {
  final ExploreContentSectionArticles section;

  const ArticleSectionView({
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
                  child: InformedMarkdownBody(
                    markdown: section.title,
                    baseTextStyle: AppTypography.h1,
                    highlightColor: AppColors.background,
                    maxLines: 2,
                  ),
                ),
                SeeAllButton(onTap: () {}),
              ],
            ),
          ),
          const SizedBox(height: AppDimens.l),
          Container(
            padding: const EdgeInsets.only(left: AppDimens.l),
            height: _mainArticleHeight,
            child: _MainArticle(
              articleHeader: section.articles[0],
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
                articleHeader: section.articles[index],
                themeColor: themeColor,
              ),
              separatorBuilder: (context, index) => const SizedBox(width: AppDimens.s),
              itemCount: section.articles.length,
            ),
          ),
          const SizedBox(height: AppDimens.xxl),
        ],
      ),
    );
  }
}

class _MainArticle extends StatelessWidget {
  final ArticleHeader articleHeader;
  final Color themeColor;

  const _MainArticle({
    required this.articleHeader,
    required this.themeColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageId = articleHeader.image?.publicId;

    return GestureDetector(
      onTap: () => CupertinoScaffold.showCupertinoModalBottomSheet(
        context: context,
        builder: (context) => ArticlePage(article: articleHeader),
        useRootNavigator: true,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) => Stack(
          children: [
            Container(
              height: _mainArticleHeight,
              child: imageId != null
                  ? Image.network(
                      CloudinaryImageExtension.withPublicId(imageId)
                          .transform()
                          .width(DimensionUtil.getPhysicalPixelsAsInt(constraints.maxWidth, context))
                          .fit()
                          .generate()!,
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
                articleHeader: articleHeader,
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
  final ArticleHeader articleHeader;
  final Color themeColor;

  const _MainArticleCover({
    required this.articleHeader,
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
            child: articleHeader.type == ArticleType.premium
                ? const ExclusiveLabel()
                : ArticleLabel.opinion(backgroundColor: themeColor),
          ),
          const Spacer(),
          Align(
            alignment: Alignment.centerLeft,
            child: Image.network(
              CloudinaryImageExtension.withPublicId(articleHeader.publisher.logo.publicId)
                  .transform()
                  .width(DimensionUtil.getPhysicalPixelsAsInt(_publisherLogoSize, context))
                  .fit()
                  .generate()!,
              width: _publisherLogoSize,
              height: _publisherLogoSize,
              fit: BoxFit.contain,
            ),
          ),
          InformedMarkdownBody(
            markdown: articleHeader.title,
            baseTextStyle: AppTypography.h3bold,
            maxLines: 4,
          ),
          const Spacer(),
          Text(
            LocaleKeys.article_readMinutes.tr(
              args: [articleHeader.timeToRead.toString()],
            ),
            style: AppTypography.metadata1Regular,
          ),
        ],
      ),
    );
  }
}
