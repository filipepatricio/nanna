import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/informed_svg.dart';
import 'package:flutter/material.dart';

class BackTextButton extends StatelessWidget {
  const BackTextButton({
    this.text,
    this.color,
    this.onPressed,
    super.key,
  });

  final String? text;
  final Color? color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final label = text ?? context.l10n.common_back;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed ?? context.popRoute,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InformedSvg(
            AppVectorGraphics.chevronBack,
            color: color ?? Theme.of(context).iconTheme.color,
          ),
          Flexible(
            child: Text(
              label,
              style: AppTypography.b2Regular.copyWith(
                color: color ?? AppColors.of(context).textPrimary,
                height: 1.11,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
