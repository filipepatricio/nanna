import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/app_config/app_urls.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/settings/main/settings_main_cubit.dart';
import 'package:better_informed_mobile/presentation/page/settings/widgets/settings_main_item.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/in_app_browser.dart';
import 'package:better_informed_mobile/presentation/widget/filled_button.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SettingsMainBody extends HookWidget {
  final SettingsMainCubit cubit;
  final SnackbarController snackbarController;

  const SettingsMainBody({
    required this.cubit,
    required this.snackbarController,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.l) + const EdgeInsets.only(top: AppDimens.l),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                Text(
                  LocaleKeys.settings_profileHeader.tr(),
                  style: AppTypography.subH1Bold.copyWith(color: AppColors.settingsHeader),
                ),
                const SizedBox(height: AppDimens.ml),
                SettingsMainItem(
                  label: LocaleKeys.settings_account.tr(),
                  icon: AppVectorGraphics.account,
                  onTap: () => AutoRouter.of(context).push(const SettingsAccountPageRoute()),
                ),
                const SizedBox(height: AppDimens.ml),
                SettingsMainItem(
                  label: LocaleKeys.settings_pushNotifications.tr(),
                  icon: AppVectorGraphics.notifications,
                  onTap: () => AutoRouter.of(context).push(const SettingsNotificationsPageRoute()),
                ),
                const SizedBox(height: AppDimens.ml),
                SettingsMainItem(
                  label: LocaleKeys.settings_inviteFriend.tr(),
                  icon: AppVectorGraphics.gift,
                  onTap: () => AutoRouter.of(context).push(const InviteFriendPageRoute()),
                ),
                const SizedBox(height: AppDimens.xxxl),
                Text(
                  LocaleKeys.settings_aboutHeader.tr(),
                  style: AppTypography.subH1Bold.copyWith(color: AppColors.settingsHeader),
                ),
                const SizedBox(height: AppDimens.ml),
                SettingsMainItem(
                  label: LocaleKeys.settings_privacyPolicy.tr(),
                  icon: AppVectorGraphics.privacy,
                  onTap: () => _openInBrowser(policyPrivacyUri),
                ),
                const SizedBox(height: AppDimens.ml),
                SettingsMainItem(
                  label: LocaleKeys.settings_termsOfService.tr(),
                  icon: AppVectorGraphics.terms,
                  onTap: () => _openInBrowser(termsOfServiceUri),
                ),
              ],
            ),
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Container(
            padding: const EdgeInsets.all(AppDimens.l),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: UnconstrainedBox(
                constrainedAxis: Axis.horizontal,
                child: FilledButton(
                  text: LocaleKeys.common_signOut.tr(),
                  fillColor: AppColors.carrotRed,
                  textColor: AppColors.white,
                  onTap: () async => await cubit.signOut(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _openInBrowser(String uri) async {
    await openInAppBrowser(
      uri,
      (error, stacktrace) {
        showBrowserError(uri, snackbarController);
      },
    );
  }
}
