import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:flutter/material.dart';

class PipeDivider extends StatelessWidget {
  const PipeDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 14,
      decoration: const BoxDecoration(
        color: AppColors.of(context).textSecondary,
        shape: BoxShape.rectangle,
      ),
    );
  }
}
