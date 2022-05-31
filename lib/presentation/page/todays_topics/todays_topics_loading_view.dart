import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/widget/loading_shimmer.dart';
import 'package:flutter/material.dart';

class TodaysTopicsLoadingView extends StatelessWidget {
  const TodaysTopicsLoadingView({
    required this.coverSize,
    Key? key,
  }) : super(key: key);

  final Size coverSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: AppDimens.xxl,
        ),
        SizedBox(
          width: coverSize.width,
          height: coverSize.height,
          child: const LoadingShimmer.defaultColor(
            radius: AppDimens.m,
          ),
        ),
        const SizedBox(
          height: AppDimens.l,
        ),
        SizedBox(
          width: coverSize.width,
          height: coverSize.height,
          child: const LoadingShimmer.defaultColor(
            radius: AppDimens.m,
          ),
        ),
      ],
    );
  }
}
