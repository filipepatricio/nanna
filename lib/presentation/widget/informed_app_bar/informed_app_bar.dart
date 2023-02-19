import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/back_text_button.dart';
import 'package:better_informed_mobile/presentation/widget/no_connection_banner/no_connection_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class InformedAppBar extends HookWidget implements PreferredSizeWidget {
  const InformedAppBar({
    this.leading,
    this.title,
    this.backgroundColor,
    this.actions,
    this.isConnected = true,
    super.key,
  });

  final Widget? leading;
  final String? title;
  final Color? backgroundColor;
  final List<Widget>? actions;
  final bool isConnected;

  @override
  Widget build(BuildContext context) {
    final title = this.title;
    final actions = this.actions;
    final leadingWidth = MediaQuery.of(context).size.width / 3;

    return AppBar(
      backgroundColor: backgroundColor ?? AppColors.of(context).backgroundPrimary,
      leading: leading ?? const BackTextButton(),
      leadingWidth: leadingWidth,
      titleSpacing: AppDimens.zero,
      centerTitle: true,
      title: title == null
          ? null
          : Text(
              title,
              style: AppTypography.h4Medium.w550.copyWith(
                color: AppColors.of(context).textPrimary,
                height: 1.11,
              ),
            ),
      actions: actions,
      bottom: isConnected ? null : const NoConnectionBanner(),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (isConnected ? 0 : NoConnectionBanner.height),
      );
}
