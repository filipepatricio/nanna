import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/entry.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/article/media_item_page.dart';
import 'package:better_informed_mobile/presentation/page/article/media_item_page_data.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/article/covers/colored_cover.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/article/covers/photo_cover.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/article/covers/photo_stacked_cover.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/editors_note.dart';
import 'package:better_informed_mobile/presentation/widget/read_more_label.dart';
import 'package:better_informed_mobile/presentation/widget/share_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ArticleItemView extends HookWidget {
  final MediaItemArticle article;
  final List<Entry> allEntries;
  final int index;
  final double statusBarHeight;
  final MediaItemNavigationCallback navigationCallback;

  const ArticleItemView({
    required this.article,
    required this.allEntries,
    required this.index,
    required this.statusBarHeight,
    required this.navigationCallback,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: change when there will be final colors or if source will be specified (for example: backend)
    final mockColoredCoverCondition = index % 3 == 1;
    final editorsNote = article.note;
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
          AutoRouter.of(context).push(
            MediaItemPageRoute(
              pageData: MediaItemPageData.multipleItems(
                index: index,
                entryList: allEntries,
                navigationCallback: navigationCallback,
              ),
            ),
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
                '${index + 1}/${allEntries.length} Afghanistan articles',
                style: AppTypography.subH1Medium,
                textAlign: TextAlign.start,
              ),
            ),
            const SizedBox(height: AppDimens.s),
            if (editorsNote != null)
              Padding(
                padding: const EdgeInsets.only(right: AppDimens.xxl),
                child: EditorsNote(note: editorsNote),
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