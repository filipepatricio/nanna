import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:flutter/material.dart';

class BulletDivider extends StatelessWidget {
  const BulletDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      height: 4,
      decoration: const BoxDecoration(
        color: AppColors.textGrey,
        shape: BoxShape.circle,
      ),
    );
  }
}
