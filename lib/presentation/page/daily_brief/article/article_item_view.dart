import 'package:better_informed_mobile/domain/article/data/article_header.dart';
import 'package:better_informed_mobile/presentation/page/article/article_page.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/article/covers/colored_cover.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/article/covers/photo_cover.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/article/covers/photo_stacked_cover.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/read_more_label.dart';
import 'package:better_informed_mobile/presentation/widget/share_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
    final mockColoredCoverCondition = index % 3 == 1;
    return Container(
      color: mockColoredCoverCondition
          ? AppColors.background
          : AppColors.mockedColors[index % AppColors.mockedColors.length],
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
            if (index % 3 == 0)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: AppDimens.l),
                  child: PhotoStackedCover(article: article),
                ),
              ),
            if (mockColoredCoverCondition)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: AppDimens.l),
                  child: ColoredCover(article: article),
                ),
              ),
            if (index % 3 == 2)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: AppDimens.m),
                  child: PhotoCover(article: article),
                ),
              ),
            const SizedBox(height: AppDimens.xl),
            Padding(
              padding: const EdgeInsets.only(right: AppDimens.l),
              child: Container(
                width: AppDimens.articleItemWidth,
                child: Row(
                  children: [
                    ShareButton(onTap: () {}),
                    const Spacer(),
                    const ReadMoreLabel(fontSize: AppDimens.m),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _calculateIndicatorWidth() => AppDimens.l * 2 + AppDimens.verticalIndicatorWidth;
}
