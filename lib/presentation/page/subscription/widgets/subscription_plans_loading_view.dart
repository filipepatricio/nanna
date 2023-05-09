import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/widget/loading_shimmer.dart';
import 'package:flutter/material.dart';

class SubscriptionPlansLoadingView extends StatelessWidget {
  const SubscriptionPlansLoadingView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        SizedBox(
          height: 50,
          child: LoadingShimmer.defaultColor(
            radius: AppDimens.m,
          ),
        ),
        SizedBox(height: AppDimens.l),
        SizedBox(
          height: 250,
          child: LoadingShimmer.defaultColor(
            radius: AppDimens.ml,
          ),
        ),
        SizedBox(height: AppDimens.m),
        SizedBox(
          height: 100,
          child: LoadingShimmer.defaultColor(
            radius: AppDimens.ml,
          ),
        ),
        SizedBox(height: AppDimens.xl),
        SizedBox(
          height: 50,
          child: LoadingShimmer.defaultColor(
            radius: AppDimens.m,
          ),
        ),
      ],
    );
  }
}
