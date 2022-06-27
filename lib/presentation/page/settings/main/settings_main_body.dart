import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/app_config/app_urls.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/settings/main/settings_main_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/settings/main/settings_main_state.dt.dart';
import 'package:better_informed_mobile/presentation/page/settings/widgets/settings_main_item.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/in_app_browser.dart';
import 'package:better_informed_mobile/presentation/widget/filled_button.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_message.dt.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:better_informed_mobile/presentation/widget/version_label/version_label.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const _feedbackEmail = 'feedback@informed.so';

class SettingsMainBody extends HookWidget {
  const SettingsMainBody({
    required this.cubit,
    required this.snackbarController,
    Key? key,
  }) : super(key: key);

  final SettingsMainCubit cubit;
  final SnackbarController snackbarController;

  @override
  Widget build(BuildContext context) {
    useCubitListener<SettingsMainCubit, SettingsMainState>(cubit, (cubit, state, context) {
      state.mapOrNull(
        sendingEmailError: (error) {
          _showEmailErrorMessage(snackbarController);
        },
      );
    });

    return CustomScrollView(
      physics: const ClampingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.only(top: AppDimens.l),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
                  child: Text(
                    LocaleKeys.settings_profileHeader.tr(),
                    style: AppTypography.subH1Bold.copyWith(color: AppColors.settingsHeader),
                  ),
                ),
                const SizedBox(height: AppDimens.l),
                SettingsMainItem(
                  label: LocaleKeys.settings_account.tr(),
                  icon: AppVectorGraphics.account,
                  onTap: () => AutoRouter.of(context).push(const SettingsAccountPageRoute()),
                ),
                const SizedBox(height: AppDimens.l),
                SettingsMainItem(
                  label: LocaleKeys.settings_notifications.tr(),
                  icon: AppVectorGraphics.notifications,
                  onTap: () => AutoRouter.of(context).push(const SettingsNotificationsPageRoute()),
                ),
                const SizedBox(height: AppDimens.l),
                SettingsMainItem(
                  label: LocaleKeys.settings_manageMyInterests.tr(),
                  icon: AppVectorGraphics.star,
                  onTap: () => AutoRouter.of(context).push(const SettingsManageMyInterestsPageRoute()),
                ),
                const SizedBox(height: AppDimens.xxxl),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
                  child: Text(
                    LocaleKeys.settings_aboutHeader.tr(),
                    style: AppTypography.subH1Bold.copyWith(color: AppColors.settingsHeader),
                  ),
                ),
                const SizedBox(height: AppDimens.l),
                SettingsMainItem(
                  label: LocaleKeys.settings_privacyPolicy.tr(),
                  icon: AppVectorGraphics.privacy,
                  onTap: () => _openInBrowser(policyPrivacyUri),
                ),
                const SizedBox(height: AppDimens.l),
                SettingsMainItem(
                  label: LocaleKeys.settings_termsOfService.tr(),
                  icon: AppVectorGraphics.terms,
                  onTap: () => _openInBrowser(termsOfServiceUri),
                ),
                const SizedBox(height: AppDimens.l),
                SettingsMainItem(
                  label: LocaleKeys.settings_feedbackButton.tr(),
                  icon: AppVectorGraphics.feedback,
                  onTap: () {
                    cubit.sendFeedbackEmail(
                      _feedbackEmail,
                      LocaleKeys.settings_feedbackSubject.tr(),
                      LocaleKeys.settings_feedbackText.tr(),
                    );
                  },
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FilledButton(
                      text: LocaleKeys.common_signOut.tr(),
                      fillColor: AppColors.carrotRed,
                      textColor: AppColors.white,
                      onTap: () => cubit.signOut(),
                    ),
                    const SizedBox(height: AppDimens.s),
                    const VersionLabel(),
                  ],
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

  void _showEmailErrorMessage(SnackbarController controller) {
    controller.showMessage(
      SnackbarMessage.custom(
        message: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: LocaleKeys.settings_feedbackMailError.tr(),
                style: AppTypography.b2Regular.copyWith(color: AppColors.white),
              ),
              TextSpan(
                text: _feedbackEmail,
                style: AppTypography.b2Regular.copyWith(
                  color: AppColors.white,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    _copyEmailToClipboard(controller);
                  },
              ),
            ],
          ),
        ),
        type: SnackbarMessageType.negative,
      ),
    );
  }

  void _copyEmailToClipboard(SnackbarController controller) {
    Clipboard.setData(const ClipboardData(text: _feedbackEmail));
    controller.showMessage(
      SnackbarMessage.simple(
        message: LocaleKeys.profile_emailCopied.tr(),
        type: SnackbarMessageType.positive,
      ),
    );
  }
}
