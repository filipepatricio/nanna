import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:flutter/material.dart';

const _size = 12.0;
const _radius = 2.0;

class MarkdownBullet extends StatelessWidget {
  const MarkdownBullet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: _size,
        width: _size,
        decoration: const BoxDecoration(
          color: AppColors.limeGreen,
          borderRadius: BorderRadius.all(
            Radius.circular(_radius),
          ),
        ),
      ),
    );
  }
}
