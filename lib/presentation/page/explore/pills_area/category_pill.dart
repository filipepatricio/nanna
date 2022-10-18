import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:flutter/material.dart';

class CategoryPill extends StatelessWidget {
  const CategoryPill({
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
        child: Text(
          title,
          style: AppTypography.b3Regular.copyWith(height: 1),
        ),
      ),
    );
  }
}
