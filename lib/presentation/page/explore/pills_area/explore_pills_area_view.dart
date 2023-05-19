import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/categories/data/category_with_items.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/widget/informed_pill.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

const _pillLines = 1;
const _pillPadding = AppDimens.s;
const _pillsTopPadding = AppDimens.zero;
const _pillsBottomPadding = AppDimens.zero;

class ExplorePillsAreaView extends StatelessWidget {
  const ExplorePillsAreaView({
    required this.categories,
  });

  final List<CategoryWithItems> categories;

  @override
  Widget build(BuildContext context) {
    final pillsAreaHeight = AppDimens.explorePillHeight(context) + _pillsTopPadding + _pillsBottomPadding;

    return SizedBox(
      height: pillsAreaHeight,
      child: MasonryGridView.count(
        padding: const EdgeInsets.only(
          left: AppDimens.pageHorizontalMargin,
          right: AppDimens.s,
          top: _pillsTopPadding,
          bottom: _pillsBottomPadding,
        ),
        scrollDirection: Axis.horizontal,
        crossAxisCount: _pillLines,
        mainAxisSpacing: _pillPadding,
        crossAxisSpacing: _pillPadding,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return InformedPill(
            title: category.name,
            color: category.color,
            onTap: () => AutoRouter.of(context).push(
              CategoryPageRoute(
                category: category,
                openedFrom: context.l10n.main_exploreTab,
              ),
            ),
          );
        },
      ),
    );
  }
}
