// inspired by: https://stackoverflow.com/a/60518707

import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:flutter/material.dart';

class PaddingTapWidget extends StatelessWidget {
  const PaddingTapWidget({
    required this.onTap,
    required this.tapPadding,
    required this.child,
    this.alignment = AlignmentDirectional.center,
    Key? key,
  }) : super(key: key);

  final VoidCallback onTap;
  final EdgeInsets tapPadding;
  final Widget child;
  final AlignmentDirectional alignment;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: alignment,
      children: [
        child,
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: onTap,
          child: Container(
            color: AppColors.transparent,
            padding: tapPadding,
          ),
        ),
      ],
    );
  }
}
