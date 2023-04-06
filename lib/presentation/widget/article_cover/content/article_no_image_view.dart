import 'dart:math';

import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/informed_svg.dart';
import 'package:flutter/material.dart';

class ArticleNoImageView extends StatelessWidget {
  const ArticleNoImageView({
    required this.color,
    required this.locked,
    super.key,
  });

  final Color? color;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox.expand(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: color ?? AppColors.of(context).blackWhiteSecondary,
              borderRadius: BorderRadius.circular(AppDimens.defaultRadius),
            ),
          ),
        ),
        if (locked)
          Positioned.fill(
            child: Center(
              child: InformedSvg(
                AppVectorGraphics.locker,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
          )
        else
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth / 2;
                final height = constraints.maxHeight / 2;

                final size = min(width, height) - AppDimens.sl * 2;

                return Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimens.sl),
                    child: InformedSvg(
                      AppVectorGraphics.imageFallback,
                      color: AppColors.brandPrimary,
                      width: size,
                      height: size,
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
