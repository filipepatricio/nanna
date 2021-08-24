import 'package:better_informed_mobile/domain/article/data/article_data.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/article/article_page.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

const articleItemWidth = 298.0;
const articleItemImageHeight = 490.0;

class ArticleItemView extends HookWidget {
  final Article article;

  const ArticleItemView({required this.article});

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (article.sourceUrl == null)
            _ColoredCover(
              article: article,
            )
          else
            _PhotoCover(article: article),
          const SizedBox(height: AppDimens.xl),
          Container(
            width: articleItemWidth,
            child: Row(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      AppVectorGraphics.share,
                      color: AppColors.black,
                    ),
                  ),
                ),
                const SizedBox(height: AppDimens.m),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      AppVectorGraphics.follow,
                      color: AppColors.black,
                    ),
                  ),
                ),
                const Spacer(),
                const Text(
                  LocaleKeys.article_readMore,
                  style: AppTypography.h5BoldSmall,
                  textAlign: TextAlign.start,
                ),
                const SizedBox(width: AppDimens.s),
                SvgPicture.asset(AppVectorGraphics.arrowRight),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _ColoredCover extends StatelessWidget {
  final Article article;

  const _ColoredCover({required this.article});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.rose,
      width: articleItemWidth,
      height: articleItemImageHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.type == ArticleType.premium) ...[
              const SizedBox(height: AppDimens.l),
              Container(
                padding: const EdgeInsets.all(AppDimens.s),
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.all(Radius.circular(AppDimens.xs)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      LocaleKeys.article_types_premium.tr().toUpperCase(),
                      style: AppTypography.labelText,
                    ),
                    const SizedBox(width: AppDimens.xs),
                    SvgPicture.asset(AppVectorGraphics.lock),
                  ],
                ),
              ),
            ],
            const Spacer(),
            Text(
              article.title,
              style: AppTypography.h0SemiBold.copyWith(fontFamily: fontFamilyLora),
              maxLines: 4,
              textAlign: TextAlign.start,
            ),
            const Spacer(),
            Row(
              children: [
                Text(article.publisherName, style: AppTypography.metadata1Regular),
                const Text(' · ', style: AppTypography.metadata1Regular),
                Text(article.publicationDate, style: AppTypography.metadata1Regular),
                const Text(' · ', style: AppTypography.metadata1Regular),
                Text(article.timeToRead, style: AppTypography.metadata1Regular),
              ],
            ),
            const SizedBox(height: AppDimens.l),
          ],
        ),
      ),
    );
  }
}

class _PhotoCover extends StatelessWidget {
  final Article article;

  const _PhotoCover({required this.article});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: articleItemWidth,
      height: articleItemImageHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Image.asset(
                    article.sourceUrl ?? 'assets/image/article_placeholder.png',
                    fit: BoxFit.fill,
                  ),
                  if (article.type == ArticleType.premium) ...[
                    Positioned(
                      top: AppDimens.l,
                      left: AppDimens.l,
                      child: Container(
                        padding: const EdgeInsets.all(AppDimens.s),
                        decoration: const BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.all(Radius.circular(AppDimens.xs)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              LocaleKeys.article_types_premium.tr().toUpperCase(),
                              style: AppTypography.labelText,
                            ),
                            const SizedBox(width: AppDimens.xs),
                            SvgPicture.asset(AppVectorGraphics.lock),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppDimens.l),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(article.publisherName, style: AppTypography.metadata1Regular),
                    const Text(' · ', style: AppTypography.metadata1Regular),
                    Text(article.publicationDate, style: AppTypography.metadata1Regular),
                    const Text(' · ', style: AppTypography.metadata1Regular),
                    Text(article.timeToRead, style: AppTypography.metadata1Regular),
                  ],
                ),
                const SizedBox(height: AppDimens.l),
                Text(
                  article.title,
                  style: AppTypography.h2Bold,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: AppDimens.l),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PhotoStackedCover extends StatelessWidget {
  final Article article;

  const _PhotoStackedCover({required this.article});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: articleItemWidth,
      height: articleItemImageHeight,
      child: Stack(
        children: [
          Image.asset(
            article.sourceUrl ?? 'assets/image/article_placeholder.png',
            fit: BoxFit.cover,
          ),
          if (article.type == ArticleType.premium) ...[
            Positioned(
              top: AppDimens.l,
              left: AppDimens.l,
              child: Container(
                padding: const EdgeInsets.all(AppDimens.s),
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.all(Radius.circular(AppDimens.xs)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      LocaleKeys.article_types_premium.tr().toUpperCase(),
                      style: AppTypography.labelText,
                    ),
                    const SizedBox(width: AppDimens.xs),
                    SvgPicture.asset(AppVectorGraphics.lock),
                  ],
                ),
              ),
            ),
          ],
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.m),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    article.title,
                    style: AppTypography.h3Bold.copyWith(color: AppColors.white),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: AppDimens.l),
                  Row(
                    children: [
                      Text(article.publisherName,
                          style: AppTypography.metadata1Regular.copyWith(color: AppColors.white)),
                      Text(
                        ' · ',
                        style: AppTypography.metadata1Regular.copyWith(color: AppColors.white),
                      ),
                      Text(
                        article.publicationDate,
                        style: AppTypography.metadata1Regular.copyWith(color: AppColors.white),
                      ),
                      Text(
                        ' · ',
                        style: AppTypography.metadata1Regular.copyWith(color: AppColors.white),
                      ),
                      Text(
                        article.timeToRead,
                        style: AppTypography.metadata1Regular.copyWith(color: AppColors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimens.l),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
