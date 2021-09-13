import 'package:better_informed_mobile/domain/explore/data/explore_content_section.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/page_dot_indicator.dart';
import 'package:better_informed_mobile/presentation/widget/page_view_stacked_card.dart';
import 'package:better_informed_mobile/presentation/widget/reading_list_cover.dart';
import 'package:better_informed_mobile/presentation/widget/see_all_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const _pageViewHeight = 500.0;

class ReadingListSectionView extends HookWidget {
  final ExploreContentSectionReadingLists section;

  const ReadingListSectionView({
    required this.section,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = usePageController(viewportFraction: 0.9);
    final width = MediaQuery.of(context).size.width * 0.9;

    return Container(
      color: AppColors.background,
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
                  ),
                ),
                const SizedBox(width: AppDimens.s),
                SeeAllButton(onTap: () {}),
              ],
            ),
          ),
          const SizedBox(height: AppDimens.l),
          Container(
            height: _pageViewHeight,
            child: PageView.builder(
              padEnds: false,
              controller: controller,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(left: AppDimens.l),
                child: ReadingListStackedCards(
                  coverSize: Size(width, _pageViewHeight),
                  child: ReadingListCover(
                    topic: section.topics[index],
                  ),
                ),
              ),
              itemCount: section.topics.length,
            ),
          ),
          const SizedBox(height: AppDimens.l),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
            child: PageDotIndicator(
              pageCount: section.topics.length,
              controller: controller,
            ),
          ),
          const SizedBox(height: AppDimens.l),
        ],
      ),
    );
  }
}
