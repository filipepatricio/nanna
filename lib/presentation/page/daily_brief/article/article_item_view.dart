import 'package:better_informed_mobile/domain/article/data/article_header.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/article/article_page.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/article/covers/colored_cover.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/article/covers/photo_cover.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/article/covers/photo_stacked_cover.dart';
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

class ArticleItemView extends HookWidget {
  final ArticleHeader article;
  final int index;
  final int articleListLength;
  final double statusBarHeight;

  const ArticleItemView({
    required this.article,
    required this.index,
    required this.articleListLength,
    required this.statusBarHeight,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: change when there will be final colors or if source will be specified (for example: backend)
    const articleTestColors = <Color>[
      Color(0xffF2E8E7),
      Color(0xffFCFAF8),
      Color(0xffF3E5F4),
    ];

    return Container(
      color: articleTestColors[index % articleTestColors.length],
      padding: EdgeInsets.only(
        top: statusBarHeight,
        bottom: AppDimens.m,
        left: _calculateIndicatorWidth(),
      ),
      child: GestureDetector(
        onTap: () {
          CupertinoScaffold.showCupertinoModalBottomSheet(
            context: context,
            builder: (context) => ArticlePage(article: article),
            useRootNavigator: true,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppDimens.l),
            Padding(
              padding: const EdgeInsets.only(right: AppDimens.xxl),
              child: Text(
                '${index + 1}/$articleListLength Afghanistan articles',
                style: AppTypography.subH1Medium,
                textAlign: TextAlign.start,
              ),
            ),
            const SizedBox(height: AppDimens.s),
            Padding(
              padding: const EdgeInsets.only(right: AppDimens.xxl),
              child: Text(
                //TODO missing data in object - editors note
                'Editors note: US troops start to arrive for Afghanistan evacuation as Taliban close in on Kabul',
                style: AppTypography.subH1Medium.copyWith(fontFamily: fontFamilyLora),
                textAlign: TextAlign.start,
              ),
            ),
            const SizedBox(height: AppDimens.l),
            //TODO: Change for proper statements (this is for mock purposes)
            if (article.publisher.name == 'Euronews') Expanded(child: PhotoStackedCover(article: article)),
            if (article.publisher.name == 'DW') Expanded(child: ColoredCover(article: article)),
            if (article.publisher.name == 'The Guardian') Expanded(child: PhotoCover(article: article)),
            const SizedBox(height: AppDimens.xl),
            Container(
              width: AppDimens.articleItemWidth,
              child: Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset(AppVectorGraphics.follow, color: AppColors.black),
                    ),
                  ),
                  const SizedBox(width: AppDimens.m),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset(AppVectorGraphics.share, color: AppColors.black),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    LocaleKeys.article_readMore.tr(),
                    style: AppTypography.h5BoldSmall,
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(width: AppDimens.s),
                  SvgPicture.asset(AppVectorGraphics.arrowRight),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _calculateIndicatorWidth() => AppDimens.l * 2 + AppDimens.verticalIndicatorWidth;
}
