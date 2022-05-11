import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_area_referred.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_content_pill.dt.dart';
import 'package:better_informed_mobile/presentation/page/explore/pills_area/explore_pill.dart';
import 'package:better_informed_mobile/presentation/routing/main_router.gr.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

const _maxPillLines = 3;
const _maxPillsPerLine = 3;
const _pillPadding = 8.0;

class ExplorePillsAreaView extends StatelessWidget {
  const ExplorePillsAreaView({
    required this.pills,
    required this.headerColor,
    Key? key,
  }) : super(key: key);

  final List<ExploreContentPill> pills;
  final Color headerColor;

  @override
  Widget build(BuildContext context) {
    final lineCount = min(_maxPillLines, (pills.length / _maxPillsPerLine).ceil());
    final height = min(
      AppDimens.explorePillAreaHeight,
      lineCount * AppDimens.explorePillHeight + (lineCount > 1 ? _pillPadding : 0),
    );

    return Container(
      height: height,
      color: headerColor,
      child: MasonryGridView.count(
        padding: const EdgeInsets.only(left: AppDimens.l, right: AppDimens.m),
        scrollDirection: Axis.horizontal,
        crossAxisCount: lineCount,
        mainAxisSpacing: _pillPadding,
        crossAxisSpacing: _pillPadding,
        itemCount: pills.length,
        itemBuilder: (context, index) {
          return pills[index].map(
            articles: (area) => ExplorePill(
              title: area.title,
              icon: area.icon,
              index: index,
              onTap: () => AutoRouter.of(context).push(
                ArticleSeeAllPageRoute(
                  areaId: area.id,
                  title: area.title,
                  referred: ExploreAreaReferred.pill,
                ),
              ),
            ),
            topics: (area) => ExplorePill(
              title: area.title,
              icon: area.icon,
              index: index,
              onTap: () => context.pushRoute(
                TopicsSeeAllPageRoute(
                  areaId: area.id,
                  title: area.title,
                  referred: ExploreAreaReferred.pill,
                ),
              ),
            ),
            unknown: (_) => const SizedBox(),
          );
        },
      ),
    );
  }
}
