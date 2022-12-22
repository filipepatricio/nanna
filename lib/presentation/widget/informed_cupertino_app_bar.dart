import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/back_text_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InformedCupertinoAppBar extends StatelessWidget implements ObstructingPreferredSizeWidget {
  const InformedCupertinoAppBar({
    this.leading,
    this.title,
    this.backgroundColor,
    this.actions,
    super.key,
  });

  final Widget? leading;
  final String? title;
  final Color? backgroundColor;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final title = this.title;
    final actions = this.actions;

    return SizedBox(
      height: double.infinity,
      child: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        backgroundColor: backgroundColor ?? AppColors.of(context).backgroundPrimary,
        border: null,
        padding: const EdgeInsetsDirectional.only(start: AppDimens.xs),
        leading: leading ?? const BackTextButton(),
        middle: title == null
            ? null
            : Text(
                title,
                style: AppTypography.h4Medium.copyWith(
                  color: AppColors.of(context).textPrimary,
                  fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.5),
                  height: 1.11,
                ),
              ),
        trailing: actions == null
            ? null
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: actions,
              ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  bool shouldFullyObstruct(BuildContext context) => true;
}
