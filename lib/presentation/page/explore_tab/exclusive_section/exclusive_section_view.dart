import 'package:better_informed_mobile/domain/article/data/article.dart';
import 'package:better_informed_mobile/domain/article/data/article_header.dart';
import 'package:better_informed_mobile/domain/article/data/publisher.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/image.dart' as article_image;
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/article/article_page.dart';
import 'package:better_informed_mobile/presentation/page/explore_tab/exclusive_section/exclusive_article_list_item.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/util/dimension_util.dart';
import 'package:better_informed_mobile/presentation/widget/exclusive_label.dart';
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

final mockedArticleList = [
  ArticleHeader(
    slug: '2021-07-27-israels-opposition-has-finally-mustered-a-majority-to-dislodge-binyamin-netanyahu',
    title: 'Israel’s opposition has finally mustered a majority to dislodge Binyamin Netanyahu',
    type: ArticleType.premium,
    publicationDate: '2021-02-03',
    timeToRead: 5,
    publisher: Publisher(name: 'NYT', logo: article_image.Image(publicId: 'publishers/the_economist')),
    image: article_image.Image(publicId: 'articles/storm'),
  ),
  ArticleHeader(
    slug: '2021-07-27-israels-opposition-has-finally-mustered-a-majority-to-dislodge-binyamin-netanyahu',
    title: 'Israels government: End of Netanyahu era?',
    type: ArticleType.premium,
    publicationDate: '2021-02-09',
    timeToRead: 3,
    publisher: Publisher(name: 'NYT', logo: article_image.Image(publicId: 'publishers/the_economist')),
    image: article_image.Image(publicId: 'articles/storm'),
  ),
  ArticleHeader(
    slug: '2021-07-27-israels-opposition-has-finally-mustered-a-majority-to-dislodge-binyamin-netanyahu',
    title: 'China allows three children in major policy shift',
    type: ArticleType.premium,
    publicationDate: '2021-02-08',
    timeToRead: 6,
    publisher: Publisher(name: 'NYT', logo: article_image.Image(publicId: 'publishers/the_economist')),
    image: article_image.Image(publicId: 'articles/storm'),
  ),
];

class ExclusiveSectionView extends StatelessWidget {
  const ExclusiveSectionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.limeGreen,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppDimens.xc),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
            child: Row(
              children: [
                const Expanded(
                  child: InformedMarkdownBody(
                    markdown: '**Exclusive** news', // TODO should be coming from API
                    baseTextStyle: AppTypography.h1,
                    highlightColor: AppColors.background,
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
              articleHeader: mockedArticleList[0],
            ),
          ),
          const SizedBox(height: AppDimens.l),
          SizedBox(
            height: listItemHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
              itemBuilder: (context, index) => ExclusiveArticleListItem(articleHeader: mockedArticleList[index]),
              separatorBuilder: (context, index) => const SizedBox(width: AppDimens.s),
              itemCount: mockedArticleList.length,
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

  const _MainArticle({
    required this.articleHeader,
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
                      CloudinaryImageExtension.withPublicId(imageId).url,
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
              child: _MainArticleCover(articleHeader: articleHeader),
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

  const _MainArticleCover({
    required this.articleHeader,
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
          const Align(
            alignment: Alignment.centerLeft,
            child: ExclusiveLabel(),
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
