import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/subscription/data/active_subscription.dt.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_origin.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/settings/subscription/settings_subscription_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/settings/subscription/widgets/subscription_section_view.dart';
import 'package:better_informed_mobile/presentation/page/subscription/widgets/subscription_benefits.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/date_format_util.dart';
import 'package:better_informed_mobile/presentation/util/in_app_browser.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_placeholder.dart';
import 'package:better_informed_mobile/presentation/widget/back_text_button.dart';
import 'package:better_informed_mobile/presentation/widget/informed_app_bar/informed_app_bar.dart';
import 'package:better_informed_mobile/presentation/widget/informed_svg.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/physics/platform_scroll_physics.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

part './widgets/change_subscription_card.dart';
part './widgets/settings_subscription_manual_premium_view.dart';
part './widgets/settings_subscription_premium_view.dart';
part './widgets/settings_subscription_trial_view.dart';

class SettingsSubscriptionPage extends HookWidget {
  const SettingsSubscriptionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<SettingsSubscriptionPageCubit>();
    final state = useCubitBuilder(cubit);
    final snackbarController = useMemoized(() => SnackbarController());

    useEffect(
      () {
        cubit.initialize();
      },
      [cubit],
    );

    Future<void> openInBrowser(BuildContext context, String uri) async {
      await openInAppBrowser(
        uri,
        (error, stacktrace) {
          showBrowserError(context, uri, snackbarController);
        },
      );
    }

    return Scaffold(
      appBar: InformedAppBar(
        isConnected: context.watch<IsConnected>(),
        leading: BackTextButton(
          text: context.l10n.settings_settings,
        ),
        title: context.l10n.subscription_membership,
      ),
      body: SnackbarParentView(
        audioPlayerResponsive: true,
        controller: snackbarController,
        child: state.maybeWhen(
          loading: () => const Loader(),
          trial: (data) => _SettingsSubscriptionTrialView(
            subscription: data,
            onManageSubscriptionPressed: data.origin.matchesCurrentPlatform
                ? cubit.openSubscriptionManagementScreen
                : () => openInBrowser(context, data.manageSubscriptionURL),
          ),
          premium: (data) => _SettingsSubscriptionPremiumView(
            subscription: data,
            onManageSubscriptionPressed: data.origin.matchesCurrentPlatform
                ? cubit.openSubscriptionManagementScreen
                : () => openInBrowser(context, data.manageSubscriptionURL),
          ),
          manualPremium: (data) => _SettingsSubscriptionManualPremiumView(
            subscription: data,
          ),
          orElse: Container.new,
        ),
      ),
    );
  }
}

extension on SubscriptionOrigin {
  bool get matchesCurrentPlatform {
    switch (this) {
      case SubscriptionOrigin.appStore:
        return Platform.isIOS;
      case SubscriptionOrigin.playStore:
        return Platform.isAndroid;
      default:
        return false;
    }
  }
}
