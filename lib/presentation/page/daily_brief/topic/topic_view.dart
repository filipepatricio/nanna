import 'package:better_informed_mobile/domain/article/data/article.dart';
import 'package:better_informed_mobile/domain/article/data/article_header.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/article/article_page.dart';
import 'package:better_informed_mobile/presentation/page/reading_banner/reading_banner_wrapper.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/widget/custom_rich_text.dart';
import 'package:better_informed_mobile/presentation/widget/hero_tag.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

const _articleIconSize = 400;

class TopicView extends StatelessWidget {
  final int index;
  final AnimationController pageTransitionAnimation;
  final Topic topic;

  const TopicView({
    required this.index,
    required this.pageTransitionAnimation,
    required this.topic,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReadingBannerWrapper(
      child: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate(
              [
                _TopicHeader(
                  index: index,
                  pageTransitionAnimation: pageTransitionAnimation,
                  topic: topic,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimens.l, vertical: AppDimens.l),
                  color: AppColors.lightGrey,
                  child: InformedMarkdownBody(
                    markdown: topic.summary,
                    baseTextStyle: AppTypography.b1Medium,
                    selectable: true,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
                  color: AppColors.lightGrey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomRichText(
                        textSpan: TextSpan(
                          text: LocaleKeys.dailyBrief_readingList.tr(),
                          style: AppTypography.h3Bold.copyWith(decoration: TextDecoration.underline),
                        ),
                      ),
                      const SizedBox(height: AppDimens.l),
                      ...topic.readingList.articles
                          .map((e) => _ArticleItem(article: e))
                          .expand(
                            (element) => [
                              element,
                              Divider(
                                height: AppDimens.one,
                                color: AppColors.textPrimary.withOpacity(0.14),
                              ),
                            ],
                          )
                          .take(topic.readingList.articles.length * 2 - 1),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ArticleItem extends HookWidget {
  final ArticleHeader article;

  const _ArticleItem({required this.article});

  @override
  Widget build(BuildContext context) {
    final imageId = article.image?.publicId;

    return GestureDetector(
      onTap: () {
        CupertinoScaffold.showCupertinoModalBottomSheet(
          context: context,
          builder: (context) => ArticlePage(article: article),
          useRootNavigator: true,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppDimens.m),
        child: Row(
          children: [
            Container(
              width: AppDimens.articleItemPhotoSize,
              height: AppDimens.articleItemPhotoSize,
              decoration: const BoxDecoration(shape: BoxShape.rectangle),
              child: imageId != null
                  ? Image.network(
                      CloudinaryImageExtension.withPublicId(imageId)
                          .transform()
                          .height(_articleIconSize)
                          .fit()
                          .generate()!,
                      fit: BoxFit.cover,
                    )
                  : Container(),
            ),
            const SizedBox(width: AppDimens.articleItemMargin),
            Expanded(
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (article.type == ArticleType.premium) ...[
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: AppDimens.xxs, horizontal: AppDimens.xs),
                              decoration: const BoxDecoration(
                                color: AppColors.limeGreen,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(AppDimens.xxs),
                                ),
                              ),
                              child: Text(
                                LocaleKeys.article_types_premium.tr().toUpperCase(),
                                style: AppTypography.labelText,
                              ),
                            ),
                            const SizedBox(width: AppDimens.xs),
                            SvgPicture.asset(AppVectorGraphics.lock),
                          ],
                        ),
                      ],
                      const Spacer(),
                      GestureDetector(
                        onTap: () => {},
                        child: SvgPicture.asset(
                          AppVectorGraphics.share,
                          width: AppDimens.l,
                          height: AppDimens.l,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: AppDimens.l),
                    child: Text(
                      article.title,
                      style: AppTypography.h3Bold,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  const SizedBox(height: AppDimens.xs),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.network(
                        CloudinaryImageExtension.withPublicId(article.publisher.logo.publicId)
                            .transform()
                            .height(AppDimens.articlePublisherLogoSize)
                            .fit()
                            .generate()!,
                        width: AppDimens.m,
                        height: AppDimens.m,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: AppDimens.xs),
                      Text(article.publisher.name, style: AppTypography.metadata1Regular),
                      const Spacer(),
                      Text(
                        article.publicationDate,
                        style: AppTypography.metadata1Regular.copyWith(color: AppColors.greyFont),
                      ),
                      Text(
                        ' · ',
                        style: AppTypography.metadata1Regular.copyWith(color: AppColors.greyFont),
                      ),
                      Text(
                        article.timeToRead.toString(),
                        style: AppTypography.metadata1Regular.copyWith(color: AppColors.greyFont),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _TopicHeader extends HookWidget {
  final int index;
  final AnimationController pageTransitionAnimation;
  final Topic topic;

  const _TopicHeader({
    required this.index,
    required this.pageTransitionAnimation,
    required this.topic,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageWidth = MediaQuery.of(context).size.width * 2;

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Hero(
          tag: HeroTag.dailyBriefTopicImage(topic.id),
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.65,
            child: Image.network(
              CloudinaryImageExtension.withPublicId(topic.image.publicId)
                  .transform()
                  .width(imageWidth.ceil())
                  .fit()
                  .generate()!,
              fit: BoxFit.fitHeight,
              alignment: Alignment.topLeft,
            ),
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  AppColors.gradientOverlayStartColor,
                  AppColors.gradientOverlayEndColor,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FadeTransition(
                  opacity: pageTransitionAnimation,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(onPressed: () {}, icon: SvgPicture.asset(AppVectorGraphics.info)),
                      const SizedBox(height: AppDimens.m),
                      IconButton(onPressed: () {}, icon: SvgPicture.asset(AppVectorGraphics.share)),
                      const SizedBox(height: AppDimens.m),
                      IconButton(onPressed: () {}, icon: SvgPicture.asset(AppVectorGraphics.follow)),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimens.l),
                Hero(
                  tag: HeroTag.dailyBriefTopicTitle(topic.id),
                  child: InformedMarkdownBody(
                    markdown: topic.title,
                    baseTextStyle: AppTypography.h1Bold.copyWith(color: Colors.white),
                  ),
                ),
                const SizedBox(height: AppDimens.s),
                Hero(
                  tag: HeroTag.dailyBriefTopicSummary(topic.id),
                  child: InformedMarkdownBody(
                    markdown: topic.introduction,
                    baseTextStyle: AppTypography.b1Medium.copyWith(color: Colors.white),
                  ),
                ),
                const SizedBox(height: AppDimens.l),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
