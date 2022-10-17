import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:flutter/material.dart';

class ExplorePill extends StatelessWidget {
  const ExplorePill({
    required this.title,
    required this.icon,
    required this.index,
    required this.onTap,
    required this.color,
    Key? key,
  }) : super(key: key);

  final String title;
  final String? icon;
  final int index;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppDimens.explorePillHeight,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(70),
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
