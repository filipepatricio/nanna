import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:flutter/material.dart';

class SeeAllLoadMoreIndicator extends StatelessWidget {
  final bool show;

  const SeeAllLoadMoreIndicator({
    required this.show,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (show) {
      return const SliverPadding(
        padding: EdgeInsets.symmetric(vertical: AppDimens.l),
        sliver: SliverToBoxAdapter(
          child: Loader(
            color: AppColors.limeGreen,
          ),
        ),
      );
    } else {
      return const SliverPadding(
        padding: EdgeInsets.only(top: AppDimens.l),
      );
    }
  }
}
