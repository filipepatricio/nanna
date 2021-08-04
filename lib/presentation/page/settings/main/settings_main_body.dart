import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/settings/main/settings_main_cubit.dart';
import 'package:better_informed_mobile/presentation/page/settings/main/widgets/settings_main_item.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SettingsMainBody extends HookWidget {
  final SettingsMainCubit cubit;

  const SettingsMainBody(this.cubit);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimens.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: <Widget>[
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        LocaleKeys.settings_profileHeader.tr(),
                        style: AppTypography.subH1Bold.copyWith(color: AppColors.settingsHeader),
                      ),
                      const SizedBox(height: AppDimens.ml),
                      SettingsMainItem(
                        label: LocaleKeys.settings_account.tr(),
                        icon: AppVectorGraphics.account,
                        onTap: () => {
                          //TODO: NAVIGATE TO ACC
                        },
                      ),
                      const SizedBox(height: AppDimens.ml),
                      SettingsMainItem(
                        label: LocaleKeys.settings_pushNotifications.tr(),
                        icon: AppVectorGraphics.notifications,
                        onTap: () => {
                          //TODO: NAVIGATE TO NOTIFI
                        },
                      ),
                      const SizedBox(height: AppDimens.ml),
                      SettingsMainItem(
                        label: LocaleKeys.settings_subscription.tr(),
                        icon: AppVectorGraphics.subscription,
                        onTap: () => {
                          //TODO: NAVIGATE TO SUB
                        },
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
                        onTap: () => AutoRouter.of(context).push(PolicyTermsPageRoute(isPolicy: true)),
                      ),
                      const SizedBox(height: AppDimens.ml),
                      SettingsMainItem(
                        label: LocaleKeys.settings_termsOfService.tr(),
                        icon: AppVectorGraphics.terms,
                        onTap: () => AutoRouter.of(context).push(PolicyTermsPageRoute(isPolicy: false)),
                      ),
                      const SizedBox(height: AppDimens.ml),
                      SettingsMainItem(
                        label: LocaleKeys.settings_giveFeedback.tr(),
                        icon: AppVectorGraphics.feedback,
                        onTap: () => {
                          //TODO: NAVIGATE TO FEEDBACK
                        },
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () async => {
              //TODO: Maybe show some are you sure dialog
              // await cubit.signOut()
            },
            child: Text(
              LocaleKeys.common_signOut.tr(),
              style: AppTypography.h4Medium.copyWith(color: AppColors.red),
            ),
          ),
          const SizedBox(height: AppDimens.ml),
        ],
      ),
    );
  }
}
