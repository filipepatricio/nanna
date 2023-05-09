import 'package:auto_route/auto_route.dart';
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
import 'package:better_informed_mobile/presentation/util/snackbar_util.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_placeholder.dart';
import 'package:better_informed_mobile/presentation/widget/physics/platform_scroll_physics.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_message.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:better_informed_mobile/presentation/widget/version_label/version_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const _feedbackEmail = 'feedback@informed.so';

class SettingsMainBody extends HookWidget {
  const SettingsMainBody({
    required this.cubit,
    Key? key,
  }) : super(key: key);

  final SettingsMainCubit cubit;

  @override
  Widget build(BuildContext context) {
    final snackbarController = useSnackbarController();

    useCubitListener<SettingsMainCubit, SettingsMainState>(cubit, (cubit, state, context) {
      state.mapOrNull(
        sendingEmailError: (error) {
          showEmailErrorMessage(context, snackbarController);
        },
      );
    });

    return ListView(
      physics: getPlatformScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: AppDimens.l),
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimens.m),
          child: SubscriptionCard(),
        ),
        const SizedBox(height: AppDimens.m),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
          child: Text(
            context.l10n.settings_profileHeader,
            style: AppTypography.subH1Bold.copyWith(
              color: AppColors.of(context).textTertiary,
            ),
          ),
        ),
        const SizedBox(height: AppDimens.s),
        SettingsMainItem(
          label: context.l10n.settings_account,
          icon: AppVectorGraphics.account,
          onTap: () => context.pushRoute(const SettingsAccountPageRoute()),
        ),
        SettingsMainItem(
          label: context.l10n.settings_notifications_title,
          icon: AppVectorGraphics.notifications,
          onTap: () => context.pushRoute(const SettingsNotificationsPageRoute()),
        ),
        SettingsMainItem(
          label: context.l10n.settings_appearance_title,
          icon: AppVectorGraphics.image,
          onTap: () => context.pushRoute(const SettingsAppearancePageRoute()),
        ),
        SettingsMainItem(
          label: context.l10n.settings_manageMyInterests,
          icon: AppVectorGraphics.star,
          onTap: () => context.pushRoute(const SettingsManageMyInterestsPageRoute()),
        ),
        const SizedBox(height: AppDimens.xl),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
          child: Text(
            context.l10n.settings_aboutHeader,
            style: AppTypography.subH1Bold.copyWith(
              color: AppColors.of(context).textTertiary,
            ),
          ),
        ),
        const SizedBox(height: AppDimens.s),
        SettingsMainItem(
          label: context.l10n.settings_privacyPolicy,
          onTap: () => context.pushRoute(
            SettingsPrivacyPolicyPageRoute(
              fromRoute: context.l10n.settings_settings,
            ),
          ),
        ),
        SettingsMainItem(
          label: context.l10n.settings_termsOfService,
          onTap: () => context.pushRoute(
            SettingsTermsOfServicePageRoute(
              fromRoute: context.l10n.settings_settings,
            ),
          ),
        ),
        SettingsMainItem(
          label: context.l10n.settings_feedbackButton,
          onTap: () {
            cubit.sendFeedbackEmail(
              _feedbackEmail,
              context.l10n.settings_feedbackSubject,
            );
          },
        ),
        SettingsMainItem(
          label: context.l10n.common_signOut,
          onTap: cubit.signOut,
          fontColor: AppColors.of(context).textTertiary,
        ),
        const SizedBox(height: AppDimens.xl),
        const Padding(
          padding: EdgeInsets.only(left: AppDimens.l),
          child: Align(
            alignment: Alignment.centerLeft,
            child: VersionLabel(),
          ),
        ),
        const AudioPlayerBannerPlaceholder(),
      ],
    );
  }

  void showEmailErrorMessage(BuildContext context, SnackbarController controller) {
    controller.showMessage(
      SnackbarMessage.simple(
        message: context.l10n.settings_feedbackMailError,
        subMessage: _feedbackEmail,
        action: SnackbarAction(
          label: context.l10n.common_copy,
          callback: () => _copyEmailToClipboard(context, controller),
        ),
        type: SnackbarMessageType.error,
      ),
    );
  }

  void _copyEmailToClipboard(BuildContext context, SnackbarController controller) {
    Clipboard.setData(const ClipboardData(text: _feedbackEmail));
    controller.showMessage(
      SnackbarMessage.simple(
        message: context.l10n.profile_emailCopied,
        type: SnackbarMessageType.success,
      ),
    );
  }
}
