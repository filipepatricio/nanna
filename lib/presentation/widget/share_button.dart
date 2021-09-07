import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ShareButton extends StatelessWidget {
  final VoidCallback onTap;

  const ShareButton({
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimens.xs),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.background,
        ),
        child: SvgPicture.asset(
          AppVectorGraphics.share,
        ),
      ),
    );
  }
}
