import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/widget/loading_shimmer.dart';
import 'package:flutter/material.dart';

class TopicLoadingView extends StatelessWidget {
  const TopicLoadingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LoadingShimmer.defaultColor(
            height: AppDimens.topicViewHeaderImageHeight(context),
          ),
          const SizedBox(height: AppDimens.xl),
          const LoadingShimmer.defaultColor(
            height: AppDimens.topicViewSummaryCardHeight + AppDimens.xc,
            padding: EdgeInsets.only(left: AppDimens.l, top: AppDimens.l),
          ),
        ],
      ),
    );
  }
}
