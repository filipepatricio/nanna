import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/categories/data/category.dt.dart';
import 'package:better_informed_mobile/presentation/page/explore/pills_area/explore_pill.dart';
import 'package:better_informed_mobile/presentation/routing/main_router.gr.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

const _maxPillLines = 3;
const _maxPillsPerLine = 3;
const _pillPadding = 8.0;
const _pillsTopPadding = AppDimens.sl;
const _pillsBottomPadding = AppDimens.ml;

class ExplorePillsAreaView extends StatelessWidget {
  const ExplorePillsAreaView({
    required this.categories,
    Key? key,
  }) : super(key: key);

  final List<Category> categories;

  @override
  Widget build(BuildContext context) {
    final lineCount = min(_maxPillLines, (categories.length / _maxPillsPerLine).ceil());
    final height = min(
          AppDimens.explorePillAreaHeight,
          lineCount * AppDimens.explorePillHeight + (lineCount > 1 ? _pillPadding : 0),
        ) +
        _pillsTopPadding +
        _pillsBottomPadding;

    return SizedBox(
      height: height,
      child: MasonryGridView.count(
        padding: const EdgeInsets.only(
          left: AppDimens.l,
          right: AppDimens.l,
          top: _pillsTopPadding,
          bottom: _pillsBottomPadding,
        ),
        scrollDirection: Axis.horizontal,
        crossAxisCount: lineCount,
        mainAxisSpacing: _pillPadding,
        crossAxisSpacing: _pillPadding,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return ExplorePill(
            title: category.name,
            icon: category.icon,
            index: index,
            onTap: () => AutoRouter.of(context).push(
              CategoryPageRoute(
                category: category,
              ),
            ),
          );
        },
      ),
    );
  }
}
