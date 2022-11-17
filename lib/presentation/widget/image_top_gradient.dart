import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:flutter/material.dart';

const _imageGradientHeight = 120.0;

class ImageTopGradient extends StatelessWidget {
  const ImageTopGradient({super.key});

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.charcoal35,
            AppColors.charcoal00,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SizedBox(height: _imageGradientHeight),
    );
  }
}
