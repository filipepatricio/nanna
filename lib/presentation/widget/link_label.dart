import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:flutter/material.dart';

class LinkLabel extends StatelessWidget {
  const LinkLabel({
    required this.label,
    required this.onTap,
    this.style = AppTypography.systemText,
    Key? key,
  }) : super(key: key);

  final String label;
  final VoidCallback onTap;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: style.copyWith(
          color: AppColors.charcoal,
          decoration: TextDecoration.underline,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}