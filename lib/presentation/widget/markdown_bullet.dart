import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:flutter/material.dart';

const _size = 6.0;

class MarkdownBullet extends StatelessWidget {
  const MarkdownBullet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: _size,
        width: _size,
        decoration: const BoxDecoration(
          color: AppColors.black,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
