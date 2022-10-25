import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/widget/loading_shimmer.dart';
import 'package:flutter/material.dart';

class DailyBriefLoadingView extends StatelessWidget {
  const DailyBriefLoadingView({
    required this.coverSize,
    Key? key,
  }) : super(key: key);

  final Size coverSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppDimens.pageHorizontalMargin,
        AppDimens.safeTopPadding(context),
        AppDimens.pageHorizontalMargin,
        AppDimens.zero,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: AppDimens.xxl,
          ),
          LoadingShimmer.defaultColor(
            width: coverSize.width,
            height: coverSize.height * .5,
            radius: AppDimens.m,
          ),
          const SizedBox(height: AppDimens.xxl),
          LoadingShimmer.defaultColor(
            width: coverSize.width,
            height: coverSize.height,
            radius: AppDimens.m,
          ),
          const SizedBox(height: AppDimens.l),
          LoadingShimmer.defaultColor(
            width: coverSize.width,
            height: coverSize.height,
            radius: AppDimens.m,
          ),
        ],
      ),
    );
  }
}
