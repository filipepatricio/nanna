import 'package:better_informed_mobile/core/util/app_link.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/filled_button.dart';
import 'package:better_informed_mobile/presentation/widget/open_web_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';

typedef OnWillPopFunction = Future<bool> Function();

class InformedDialog extends HookWidget {
  const InformedDialog._({
    required this.title,
    required this.text,
    this.icon,
    this.secondaryText,
    this.action,
    this.onWillPop,
    Key? key,
  }) : super(key: key);

  final Widget? icon;
  final String title;
  final String text;
  final String? secondaryText;
  final Widget? action;
  final OnWillPopFunction? onWillPop;

  static String get noConnectionDialogRouteName => 'NoConnectionDialog';

  static String get appUpdateDialogRouteName => 'AppUpdateDialog';

  static String get deleteAccountDialogRouteName => 'DeleteAccountDialog';

  static Future<void> showNoConnection(BuildContext context, {required OnWillPopFunction onWillPop}) {
    return show<void>(
      context,
      routeName: noConnectionDialogRouteName,
      icon: SvgPicture.asset(
        AppVectorGraphics.megaphone,
        width: AppDimens.onboardingIconSize,
        height: AppDimens.onboardingIconSize,
        fit: BoxFit.contain,
      ),
      title: LocaleKeys.noConnection_title.tr(),
      text: LocaleKeys.noConnection_body.tr(),
      onWillPop: onWillPop,
    );
  }

  static Future<void> showAppUpdate(BuildContext context, {OnWillPopFunction? onWillPop, String? availableVersion}) {
    return show<void>(
      context,
      routeName: appUpdateDialogRouteName,
      icon: SvgPicture.asset(
        AppVectorGraphics.megaphone,
        width: AppDimens.onboardingIconSize,
        height: AppDimens.onboardingIconSize,
        fit: BoxFit.contain,
      ),
      title: LocaleKeys.update_title.tr(),
      text: LocaleKeys.update_body.tr(),
      secondaryText: availableVersion != null ? LocaleKeys.update_versionAvailable.tr(args: [availableVersion]) : null,
      action: OpenWebButton(
        withIcon: false,
        url: platformStoreLink,
        buttonLabel: LocaleKeys.update_button.tr(),
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.c),
        launchExternalApp: true,
      ),
      onWillPop: onWillPop ?? () async => true,
    );
  }

  static Future<bool?> showDeleteAccount(BuildContext context) async => show<bool>(
        context,
        routeName: appUpdateDialogRouteName,
        title: LocaleKeys.settings_deleteAccount_dialogTitle.tr(),
        text: LocaleKeys.settings_deleteAccount_dialogBody.tr(),
        dismissible: true,
        action: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 6,
              child: FilledButton(
                text: LocaleKeys.common_cancel.tr(),
                fillColor: AppColors.black05,
                onTap: () => Navigator.pop(context, false),
              ),
            ),
            const Spacer(),
            Expanded(
              flex: 6,
              child: FilledButton(
                text: LocaleKeys.settings_deleteAccount_delete.tr(),
                fillColor: AppColors.carrotRed,
                textColor: AppColors.white,
                onTap: () => Navigator.pop(context, true),
              ),
            ),
          ],
        ),
      );

  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required String text,
    required String routeName,
    bool dismissible = false,
    Widget? icon,
    String? secondaryText,
    Widget? action,
    OnWillPopFunction? onWillPop,
  }) =>
      showDialog<T>(
        context: context,
        useRootNavigator: true,
        barrierDismissible: dismissible,
        barrierColor: AppColors.black40,
        routeSettings: RouteSettings(name: routeName),
        builder: (context) => InformedDialog._(
          title: title,
          text: text,
          icon: icon,
          secondaryText: secondaryText,
          action: action,
          onWillPop: onWillPop,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: SimpleDialog(
        insetPadding: const EdgeInsets.symmetric(
          horizontal: AppDimens.l,
          vertical: AppDimens.l,
        ),
        contentPadding: const EdgeInsets.fromLTRB(
          AppDimens.l,
          AppDimens.xl,
          AppDimens.l,
          AppDimens.xxl,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(height: AppDimens.l),
              ],
              Text(
                title,
                style: AppTypography.h4Bold,
              ),
              const SizedBox(height: AppDimens.m),
              Text(
                text,
                style: AppTypography.b2Regular,
              ),
              if (secondaryText != null) ...[
                const SizedBox(height: AppDimens.l),
                Text(
                  secondaryText!,
                  style: AppTypography.b2Regular.copyWith(color: AppColors.textGrey),
                ),
              ],
              if (action != null) ...[
                const SizedBox(height: AppDimens.l),
                Center(child: action),
              ]
            ],
          ),
        ],
      ),
    );
  }
}
