import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sliver_tools/sliver_tools.dart';

const _gridColumnCount = 2;

class ItemsGridView extends StatelessWidget {
  const ItemsGridView({
    required this.itemCount,
    required this.itemBuilder,
    required this.scrollController,
    this.withLoader = false,
    Key? key,
  }) : super(key: key);

  final int itemCount;
  final NullableIndexedWidgetBuilder itemBuilder;
  final ScrollController scrollController;
  final bool withLoader;

  @override
  Widget build(BuildContext context) {
    return MultiSliver(
      children: [
        SliverPadding(
          padding: const EdgeInsets.all(AppDimens.l),
          sliver: SliverAlignedGrid.count(
            crossAxisCount: _gridColumnCount,
            mainAxisSpacing: AppDimens.l,
            crossAxisSpacing: AppDimens.l,
            itemCount: itemCount,
            itemBuilder: itemBuilder,
          ),
        ),
        if (withLoader)
          const SliverPadding(
            padding: EdgeInsets.all(AppDimens.xl),
            sliver: SliverToBoxAdapter(
              child: Loader(
                color: AppColors.limeGreen,
              ),
            ),
          ),
      ],
    );
  }
}
