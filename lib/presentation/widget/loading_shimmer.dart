import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingShimmer extends StatelessWidget {
  const LoadingShimmer({
    required this.mainColor,
    this.baseColor = AppColors.background,
    this.enabled = true,
    EdgeInsets? padding,
    double? height,
    double? width,
    double? radius,
    Key? key,
  })  : padding = padding ?? EdgeInsets.zero,
        height = height ?? double.infinity,
        width = width ?? double.infinity,
        radius = radius ?? 0,
        super(key: key);

  const LoadingShimmer.defaultColor({
    bool enabled = true,
    EdgeInsets? padding,
    double? height,
    double? width,
    double? radius,
    Key? key,
  }) : this(
          mainColor: AppColors.pastelGreen,
          enabled: enabled,
          padding: padding,
          height: height,
          width: width,
          radius: radius,
          key: key,
        );
  final Color mainColor;
  final Color baseColor;
  final bool enabled;
  final EdgeInsets padding;
  final double height;
  final double width;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(
        Radius.circular(
          radius,
        ),
      ),
      child: Container(
        padding: padding,
        height: height,
        width: width,
        child: Shimmer.fromColors(
          enabled: enabled && !kIsTest,
          direction: ShimmerDirection.ltr,
          baseColor: baseColor,
          highlightColor: mainColor,
          child: Container(color: AppColors.background),
        ),
      ),
    );
  }
}
