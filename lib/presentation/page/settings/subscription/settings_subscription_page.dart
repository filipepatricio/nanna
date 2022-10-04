import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/subscription/data/active_subscription.dt.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/settings/subscription/settings_subscription_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/subscription/widgets/subscription_benefits.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/date_format_util.dart';
import 'package:better_informed_mobile/presentation/util/in_app_browser.dart';
import 'package:better_informed_mobile/presentation/widget/informed_divider.dart';
import 'package:better_informed_mobile/presentation/widget/link_label.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/physics/platform_scroll_physics.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';

part './widgets/change_subscription_card.dart';
part './widgets/settings_subscription_premium_view.dart';
part './widgets/settings_subscription_trial_view.dart';

class SettingsSubscriptionPage extends HookWidget {
  const SettingsSubscriptionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<SettingsSubscriptionPageCubit>();
    final state = useCubitBuilder(cubit);
    final snackbarController = useMemoized(() => SnackbarController(audioPlayerResponsive: true));

    useEffect(
      () {
        cubit.initialize();
      },
      [cubit],
    );

    Future<void> _openInBrowser(String uri) async {
      await openInAppBrowser(
        uri,
        (error, stacktrace) {
          showBrowserError(uri, snackbarController);
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        centerTitle: false,
        titleSpacing: 0.0,
        title: Text(
          LocaleKeys.settings_settings.tr(),
          style: AppTypography.subH1Medium,
        ),
      ),
      body: SnackbarParentView(
        controller: snackbarController,
        child: state.maybeWhen(
          loading: () => const Loader(),
          trial: (data) => _SettingsSubscriptionTrialView(
            subscription: data,
            onCancelSubscriptionTap: () => _openInBrowser(data.manageSubscriptionURL),
          ),
          premium: (data) => _SettingsSubscriptionPremiumView(
            subscription: data,
            onCancelSubscriptionTap: () => _openInBrowser(data.manageSubscriptionURL),
          ),
          orElse: Container.new,
        ),
      ),
    );
  }
}