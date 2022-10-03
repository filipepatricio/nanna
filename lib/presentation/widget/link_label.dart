import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:flutter/material.dart';

class LinkLabel extends StatelessWidget {
  const LinkLabel({
    required this.label,
    required this.onTap,
    this.style = AppTypography.systemText,
    this.align = TextAlign.center,
    Key? key,
  }) : super(key: key);

  final String label;
  final VoidCallback onTap;
  final TextStyle style;
  final TextAlign align;

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
        textAlign: align,
      ),
    );
  }
}
