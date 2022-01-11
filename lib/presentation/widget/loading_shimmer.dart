import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingShimmer extends StatelessWidget {
  const LoadingShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      enabled: !kIsTest,
      direction: ShimmerDirection.ltr,
      baseColor: AppColors.background,
      highlightColor: AppColors.pastelGreen.withOpacity(0.8),
      child: Container(color: AppColors.background),
    );
  }
}
