import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:flutter/material.dart';

const _size = 6.0;

class MarkdownBullet extends StatelessWidget {
  const MarkdownBullet({Key? key, this.padding}) : super(key: key);

  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Center(
        child: Container(
          height: _size,
          width: _size,
          decoration: const BoxDecoration(
            color: AppColors.black,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
