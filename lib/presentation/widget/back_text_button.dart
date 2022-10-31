import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BackTextButton extends StatelessWidget {
  const BackTextButton({
    this.text,
    this.color = AppColors.textPrimary,
    this.onPressed,
    super.key,
  });

  final String? text;
  final Color color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final label = text ?? LocaleKeys.common_back.tr();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed ?? context.popRoute,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: AppDimens.xs),
          SvgPicture.asset(
            AppVectorGraphics.chevronBack,
            color: color,
          ),
          Flexible(
            child: Text(
              label,
              style: AppTypography.b2Regular.copyWith(
                height: 1.11,
                color: color,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
