import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/hero_tag.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/page_view_stacked_card.dart';
import 'package:better_informed_mobile/presentation/widget/reading_list_cover_small.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

const _itemHeight = 320.0;

class ReadingListSeeAllPage extends StatelessWidget {
  final String title;
  final List<Topic> topics;

  const ReadingListSeeAllPage({
    required this.title,
    required this.topics,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoScaffold(
      body: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          title: Text(
            tr(LocaleKeys.explore_title),
            style: AppTypography.h3bold,
          ),
          leading: IconButton(
            onPressed: () => AutoRouter.of(context).pop(),
            icon: RotatedBox(
              quarterTurns: 2,
              child: SvgPicture.asset(
                AppVectorGraphics.arrowRight,
                height: AppDimens.backArrowSize,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppDimens.xc),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
              child: Hero(
                // TODO change to some ID or UUID if available
                tag: HeroTag.exploreReadingListTitle(title.hashCode),
                child: InformedMarkdownBody(
                  markdown: title,
                  baseTextStyle: AppTypography.h1,
                ),
              ),
            ),
            const SizedBox(height: AppDimens.m),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.only(
                  left: AppDimens.l,
                  top: AppDimens.m,
                  bottom: AppDimens.m,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: _itemHeight,
                  mainAxisSpacing: AppDimens.m,
                ),
                itemCount: topics.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _onReadingListTap(context, index),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return ReadingListStackedCards(
                          coverSize: Size(constraints.maxWidth, _itemHeight),
                          child: ReadingListCoverSmall(topic: topics[index]),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onReadingListTap(BuildContext context, int index) {
    AutoRouter.of(context).push(
      SingleTopicPageRoute(
        topic: topics[index],
      ),
    );
  }
}
