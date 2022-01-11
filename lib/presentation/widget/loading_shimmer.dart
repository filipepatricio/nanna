import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingShimmer extends StatelessWidget {
  final Color mainColor;
  final bool enabled;

  const LoadingShimmer({
    required this.mainColor,
    this.enabled = true,
    Key? key,
  }) : super(key: key);

  const LoadingShimmer.defaultColor({
    bool enabled = true,
    Key? key,
  }) : this(
          mainColor: AppColors.pastelGreen,
          enabled: enabled,
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      enabled: enabled && !kIsTest,
      direction: ShimmerDirection.ltr,
      baseColor: AppColors.background,
      highlightColor: mainColor,
      child: Container(color: AppColors.background),
    );
  }
}
