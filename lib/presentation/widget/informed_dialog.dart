import 'package:better_informed_mobile/core/util/app_link.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/filled_button.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/open_web_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

typedef OnWillPopFunction = Future<bool> Function();

class InformedDialog extends HookWidget {
  const InformedDialog._({
    required this.title,
    this.text,
    this.secondaryText,
    this.action,
    this.onWillPop,
    Key? key,
  }) : super(key: key);

  final String title;
  final String? text;
  final String? secondaryText;
  final Widget? action;
  final OnWillPopFunction? onWillPop;

  static String get appUpdateDialogRouteName => 'AppUpdateDialog';

  static String get deleteAccountDialogRouteName => 'DeleteAccountDialog';

  static String get restorePurchaseDialogRouteName => 'RestorePurchaseDialog';

  static Future<void> showAppUpdate(
    BuildContext context, {
    required OnWillPopFunction onWillPop,
    String? availableVersion,
  }) {
    return show<void>(
      context,
      routeName: appUpdateDialogRouteName,
      title: context.l10n.update_title,
      text: context.l10n.update_body,
      secondaryText: availableVersion != null ? context.l10n.update_versionAvailable(availableVersion) : null,
      action: OpenWebButton(
        withIcon: false,
        url: platformStoreLink,
        buttonLabel: context.l10n.update_button,
        launchExternalApp: true,
      ),
      onWillPop: onWillPop,
    );
  }

  static Future<bool?> showDeleteAccount(BuildContext context) async {
    return show<bool>(
      context,
      routeName: deleteAccountDialogRouteName,
      title: context.l10n.settings_deleteAccount_dialogTitle,
      text: context.l10n.settings_deleteAccount_dialogBody,
      dismissible: true,
      action: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 6,
            child: InformedFilledButton.secondary(
              context: context,
              withOutline: false,
              text: context.l10n.common_cancel,
              onTap: () => Navigator.of(context, rootNavigator: true).pop(false),
            ),
          ),
          const Spacer(),
          Expanded(
            flex: 6,
            child: InformedFilledButton.negative(
              text: context.l10n.settings_deleteAccount_delete,
              onTap: () => Navigator.of(context, rootNavigator: true).pop(true),
            ),
          ),
        ],
      ),
    );
  }

  static Future<void> showRestorePurchase(BuildContext context) {
    return show<void>(
      context,
      routeName: restorePurchaseDialogRouteName,
      title: context.l10n.subscription_restoringPurchase,
      action: const Loader(strokeWidth: 2),
    );
  }

  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required String routeName,
    String? text,
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
        barrierColor: AppColors.overlay,
        routeSettings: RouteSettings(name: routeName),
        builder: (context) => InformedDialog._(
          title: title,
          text: text,
          secondaryText: secondaryText,
          action: action,
          onWillPop: onWillPop,
        ),
      );

  static void removeRestorePurchase(BuildContext context) {
    Navigator.of(context, rootNavigator: true).popUntil(
      (route) => route.settings.name != restorePurchaseDialogRouteName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: SimpleDialog(
        insetPadding: const EdgeInsets.symmetric(
          horizontal: AppDimens.l,
          vertical: AppDimens.l,
        ),
        contentPadding: const EdgeInsets.all(AppDimens.l),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.modalRadius),
        ),
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.h0Medium,
              ),
              if (text != null) ...[
                const SizedBox(height: AppDimens.m),
                Text(
                  text!,
                  style: AppTypography.b2Regular,
                ),
              ],
              if (secondaryText != null) ...[
                const SizedBox(height: AppDimens.l),
                Text(
                  secondaryText!,
                  style: AppTypography.b2Regular.copyWith(
                    color: AppColors.of(context).textTertiary,
                  ),
                ),
              ],
              if (action != null) ...[
                const SizedBox(height: AppDimens.l),
                action!,
              ]
            ],
          ),
        ],
      ),
    );
  }
}
