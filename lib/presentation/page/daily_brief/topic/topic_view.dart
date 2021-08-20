import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/article/article_data.dart';
import 'package:better_informed_mobile/presentation/page/article/article_page.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/widget/hero_tag.dart';
import 'package:better_informed_mobile/presentation/widget/markdown_bullet.dart';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

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
    return CustomScrollView(
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
                color: Colors.white,
                child: MarkdownBody(
                  data: topic.summary,
                  styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                      p: AppTypography.b1Medium,
                      strong: AppTypography.h3Bold,
                      listBullet: AppTypography.b1Medium,
                      listBulletPadding: const EdgeInsets.symmetric(vertical: AppDimens.s)),
                  bulletBuilder: (index, style) => const MarkdownBullet(),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      LocaleKeys.dailyBrief_readingList.tr(),
                      style: AppTypography.h3Bold.copyWith(
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.limeGreen,
                      ),
                    ),
                    const SizedBox(height: AppDimens.l),
                    _ArticleItem(
                      article: ArticleData(
                        title:
                            'AstraZeneca vaccine suspension: Expert says that we have to go this is long text title 1',
                        content:
                            'SINGAPORE — Asia’s economic recovery could slow down as more countries suspend the use of the Covid-19 vaccine developed by AstraZeneca and the University of Oxford, warned the chief Asia-Pacific economist of Moody’s Analytics. Reports of blood clots in some people who received the AstraZeneca-Oxford shot led several countries — many of them in Europe — to temporarily stop using the vaccine. The World Health Organization said there’s no link between the shot and an increased risk of developing blood clots and is investigating.  Vaccine impact on global trade',
                        publicationDate: '17 Feb',
                        type: ArticleType.premium,
                        timeToRead: '4 min read',
                        sourceUrl: 'assets/image/topic_placeholder.png',
                        publisherName: 'Euro news',
                        authorName: 'Yenn Nee Lee',
                        photoText:
                            'Reports of blood clots in some people who received the AstraZeneca-Oxford shot led several countries – many of them in Europe – to temporarily stop using  the vaccine.',
                      ),
                    ),
                    Divider(
                      height: AppDimens.one,
                      color: AppColors.textPrimary.withOpacity(0.14),
                    ),
                    _ArticleItem(
                      article: ArticleData(
                        title: 'Pfizer vaccine suspension: Expert says that we have to go this is long text title 1',
                        content:
                            'SINGAPORE — Asia’s economic recovery could slow down as more countries suspend the use of the Covid-19 vaccine developed by AstraZeneca and the University of Oxford, warned the chief Asia-Pacific economist of Moody’s Analytics. Reports of blood clots in some people who received the AstraZeneca-Oxford shot led several countries — many of them in Europe — to temporarily stop using the vaccine. The World Health Organization said there’s no link between the shot and an increased risk of developing blood clots and is investigating.  Vaccine impact on global trade',
                        publicationDate: '12 Jan',
                        type: ArticleType.freemium,
                        timeToRead: '12 min read',
                        sourceUrl: 'assets/image/topic_placeholder.png',
                        publisherName: 'Polsat news',
                        authorName: 'Yenn Nee Lee',
                        photoText:
                            'Reports of blood clots in some people who received the AstraZeneca-Oxford shot led several countries – many of them in Europe – to temporarily stop using  the vaccine.',
                      ),
                    ),
                    Divider(
                      height: AppDimens.one,
                      color: AppColors.textPrimary.withOpacity(0.14),
                    ),
                    _ArticleItem(
                      article: ArticleData(
                        title: 'Moderna vaccine suspension: Expert says that we have to go this is long text title 1',
                        content:
                            'SINGAPORE — Asia’s economic recovery could slow down as more countries suspend the use of the Covid-19 vaccine developed by AstraZeneca and the University of Oxford, warned the chief Asia-Pacific economist of Moody’s Analytics. Reports of blood clots in some people who received the AstraZeneca-Oxford shot led several countries — many of them in Europe — to temporarily stop using the vaccine. The World Health Organization said there’s no link between the shot and an increased risk of developing blood clots and is investigating.  Vaccine impact on global trade',
                        publicationDate: '1 Sep',
                        type: ArticleType.premium,
                        timeToRead: '2 min read',
                        sourceUrl: 'assets/image/topic_placeholder.png',
                        publisherName: 'Fake news',
                        authorName: 'Yenn Nee Lee',
                        photoText:
                            'Reports of blood clots in some people who received the AstraZeneca-Oxford shot led several countries – many of them in Europe – to temporarily stop using  the vaccine.',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ArticleItem extends HookWidget {
  final ArticleData article;

  const _ArticleItem({required this.article});

  @override
  Widget build(BuildContext context) {
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
              child: Image.asset(
                article.sourceUrl,
                fit: BoxFit.cover,
              ),
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
                    children: [
                      SvgPicture.asset(
                        AppVectorGraphics.notifications,
                        width: AppDimens.m,
                        height: AppDimens.m,
                      ),
                      const SizedBox(width: AppDimens.xs),
                      Text(article.publisherName, style: AppTypography.metadata1Regular),
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
                        article.timeToRead,
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
                  child: Text(
                    topic.title,
                    style: AppTypography.h1Bold.copyWith(color: Colors.white),
                  ),
                ),
                const SizedBox(height: AppDimens.s),
                Hero(
                  tag: HeroTag.dailyBriefTopicSummary(topic.id),
                  child: Text(
                    topic.introduction,
                    style: AppTypography.b1Medium.copyWith(color: Colors.white),
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
