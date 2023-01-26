import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class NoConnectionBanner extends HookWidget implements PreferredSizeWidget {
  const NoConnectionBanner({super.key});

  static const height = 34.0;
  static const appBarHeight = height - AppDimens.s;

  @override
  Size get preferredSize => const Size(double.infinity, height);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.stateTextPrimary,
      padding: const EdgeInsets.all(AppDimens.s),
      child: Center(
        child: Text(
          LocaleKeys.noConnection_banner.tr(),
          style: AppTypography.sansTextNanoLausanne.copyWith(height: 1),
        ),
      ),
    );
  }
}
