import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
              child: SvgPicture.asset(
                AppVectorGraphics.locker,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
          )
        else
          Positioned.fill(
            child: Center(
              child: SvgPicture.asset(
                AppVectorGraphics.noImage,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
          ),
      ],
    );
  }
}
