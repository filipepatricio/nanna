import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingShimmer extends StatelessWidget {
  const LoadingShimmer({
    required this.mainColor,
    this.baseColor = AppColors.lightGrey,
    this.enabled = true,
    this.child,
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
    Widget? child,
    Key? key,
  }) : this(
          mainColor: AppColors.white,
          enabled: enabled,
          padding: padding,
          height: height,
          width: width,
          radius: radius,
          child: child,
          key: key,
        );

  final Color mainColor;
  final Color baseColor;
  final bool enabled;
  final EdgeInsets padding;
  final double height;
  final double width;
  final double radius;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return child != null
        ? Shimmer.fromColors(
            enabled: enabled && !kIsTest,
            direction: ShimmerDirection.ltr,
            baseColor: baseColor,
            highlightColor: mainColor,
            child: child!,
          )
        : ClipRRect(
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
                child: Container(color: baseColor),
              ),
            ),
          );
  }
}
