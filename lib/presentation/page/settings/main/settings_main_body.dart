import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/app_config/app_urls.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/settings/main/settings_main_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/settings/main/settings_main_state.dt.dart';
import 'package:better_informed_mobile/presentation/page/settings/subscription/subscription_card/subscription_card.dart';
import 'package:better_informed_mobile/presentation/page/settings/widgets/settings_main_item.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/in_app_browser.dart';
import 'package:better_informed_mobile/presentation/util/snackbar_util.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_placeholder.dart';
import 'package:better_informed_mobile/presentation/widget/physics/platform_scroll_physics.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_message.dt.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:better_informed_mobile/presentation/widget/version_label/version_label.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const _feedbackEmail = 'feedback@informed.so';

class SettingsMainBody extends HookWidget {
  const SettingsMainBody({
    required this.cubit,
    required this.useSubscriptions,
    Key? key,
  }) : super(key: key);

  final SettingsMainCubit cubit;
  final bool useSubscriptions;

  @override
  Widget build(BuildContext context) {
    final snackbarController = useSnackbarController();

    useCubitListener<SettingsMainCubit, SettingsMainState>(cubit, (cubit, state, context) {
      state.mapOrNull(
        sendingEmailError: (error) {
          _showEmailErrorMessage(snackbarController);
        },
      );
    });

    return ListView(
      physics: getPlatformScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: AppDimens.l),
      children: [
        if (useSubscriptions) ...[
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimens.m),
            child: SubscriptionCard(),
          ),
          const SizedBox(height: AppDimens.m),
        ],
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
          child: Text(
            LocaleKeys.settings_profileHeader.tr(),
            style: AppTypography.subH1Bold.copyWith(color: AppColors.settingsHeader),
          ),
        ),
        const SizedBox(height: AppDimens.s),
        SettingsMainItem(
          label: LocaleKeys.settings_account.tr(),
          icon: AppVectorGraphics.account,
          onTap: () => AutoRouter.of(context).push(const SettingsAccountPageRoute()),
        ),
        SettingsMainItem(
          label: LocaleKeys.settings_notifications.tr(),
          icon: AppVectorGraphics.notifications,
          onTap: () => AutoRouter.of(context).push(const SettingsNotificationsPageRoute()),
        ),
        SettingsMainItem(
          label: LocaleKeys.settings_manageMyInterests.tr(),
          icon: AppVectorGraphics.star,
          onTap: () => AutoRouter.of(context).push(const SettingsManageMyInterestsPageRoute()),
        ),
        const SizedBox(height: AppDimens.xl),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
          child: Text(
            LocaleKeys.settings_aboutHeader.tr(),
            style: AppTypography.subH1Bold.copyWith(color: AppColors.settingsHeader),
          ),
        ),
        const SizedBox(height: AppDimens.s),
        SettingsMainItem(
          label: LocaleKeys.settings_privacyPolicy.tr(),
          onTap: () => _openInBrowser(policyPrivacyUri, snackbarController),
        ),
        SettingsMainItem(
          label: LocaleKeys.settings_termsOfService.tr(),
          onTap: () => _openInBrowser(termsOfServiceUri, snackbarController),
        ),
        SettingsMainItem(
          label: LocaleKeys.settings_feedbackButton.tr(),
          onTap: () {
            cubit.sendFeedbackEmail(
              _feedbackEmail,
              LocaleKeys.settings_feedbackSubject.tr(),
            );
          },
        ),
        SettingsMainItem(
          label: LocaleKeys.common_signOut.tr(),
          onTap: () => cubit.signOut(),
          fontColor: AppColors.darkerGrey,
        ),
        const _VersionBox(),
        const AudioPlayerBannerPlaceholder(),
      ],
    );
  }

  Future<void> _openInBrowser(String uri, SnackbarController snackbarController) async {
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

class _VersionBox extends StatelessWidget {
  const _VersionBox();

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: AppDimens.l),
        child: SizedBox(
          height: 54,
          child: Align(
            alignment: Alignment.centerLeft,
            child: VersionLabel(),
          ),
        ),
      ),
    );
  }
}
