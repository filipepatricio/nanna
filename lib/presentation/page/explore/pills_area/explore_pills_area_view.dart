import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/categories/data/category_with_items.dart';
import 'package:better_informed_mobile/presentation/page/explore/pills_area/explore_pill.dart';
import 'package:better_informed_mobile/presentation/routing/main_router.gr.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

const _pillLines = 1;
const _pillPadding = AppDimens.s;
const _pillsTopPadding = AppDimens.zero;
const _pillsBottomPadding = AppDimens.zero;
const _pillsAreaHeight = AppDimens.explorePillHeight + _pillsTopPadding + _pillsBottomPadding;

class ExplorePillsAreaView extends StatelessWidget {
  const ExplorePillsAreaView({
    required this.categories,
    Key? key,
  }) : super(key: key);

  final List<CategoryWithItems> categories;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _pillsAreaHeight,
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
          return ExplorePill(
            title: category.name,
            color: category.color,
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
