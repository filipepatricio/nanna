import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:flutter/material.dart';

class LinkLabel extends StatelessWidget {
  const LinkLabel({
    required this.label,
    required this.onTap,
    this.style = AppTypography.systemText,
    this.align = TextAlign.center,
    this.decoration = TextDecoration.underline,
    Key? key,
  }) : super(key: key);

  final String label;
  final VoidCallback onTap;
  final TextStyle style;
  final TextAlign align;
  final TextDecoration decoration;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: style.copyWith(decoration: decoration),
        textAlign: align,
      ),
    );
  }
}
