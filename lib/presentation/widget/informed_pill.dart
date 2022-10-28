import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:flutter/material.dart';

class InformedPill extends StatelessWidget {
  const InformedPill({
    required this.title,
    required this.color,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final String title;
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppDimens.explorePillHeight,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(AppDimens.explorePillRadius),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: AppDimens.s,
          horizontal: AppDimens.m,
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: AppTypography.b3Regular.copyWith(height: 1.1),
        ),
      ),
    );
  }
}
