import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:flutter/material.dart';

class SeeAllLoadMoreIndicator extends StatelessWidget {
  const SeeAllLoadMoreIndicator({
    required this.show,
    Key? key,
  }) : super(key: key);
  final bool show;

  @override
  Widget build(BuildContext context) {
    if (show) {
      return const SliverPadding(
        padding: EdgeInsets.symmetric(vertical: AppDimens.l),
        sliver: SliverToBoxAdapter(
          child: Loader(),
        ),
      );
    } else {
      return const SliverPadding(
        padding: EdgeInsets.only(top: AppDimens.l),
      );
    }
  }
}
