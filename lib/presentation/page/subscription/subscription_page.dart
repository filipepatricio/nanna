import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/subscription/subscription_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/subscription/subscription_page_state.dt.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/in_app_browser.dart';
import 'package:better_informed_mobile/presentation/util/iterable_utils.dart';
import 'package:better_informed_mobile/presentation/widget/informed_animated_switcher.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/loading_shimmer.dart';
import 'package:better_informed_mobile/presentation/widget/physics/platform_scroll_physics.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_message.dt.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:better_informed_mobile/presentation/widget/subscription/subscribe_button.dart';
import 'package:better_informed_mobile/presentation/widget/subscription/subscription_plan_card.dart';
import 'package:better_informed_mobile/presentation/widget/subscription/subscrption_links_footer.dart';
import 'package:better_informed_mobile/presentation/widget/track/general_event_tracker/general_event_tracker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

part 'widgets/subscription_plans_loading_view.dart';
part 'widgets/subscription_plans_view.dart';

typedef OpenInBrowserFunction = Future<void> Function(String);

class SubscriptionPage extends HookWidget {
  const SubscriptionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<SubscriptionPageCubit>();
    final state = useCubitBuilder<SubscriptionPageCubit, SubscriptionPageState>(cubit);
    final snackbarController = useMemoized(() => SnackbarController());
    final eventController = useEventTrackingController();

    useEffect(
      () {
        cubit.initialize();
      },
      [cubit],
    );

    useCubitListener<SubscriptionPageCubit, SubscriptionPageState>(cubit, (cubit, state, context) {
      state.whenOrNull(
        generalError: () {
          snackbarController.showMessage(
            SnackbarMessage.simple(
              message: LocaleKeys.common_error_tryAgainLater.tr(),
              type: SnackbarMessageType.negative,
            ),
          );
        },
      );
    });

    Future<void> _openInBrowser(String uri) async {
      await openInAppBrowser(
        uri,
        (error, stacktrace) {
          showBrowserError(uri, snackbarController);
        },
      );
    }

    return SafeArea(
      bottom: false,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppDimens.m)),
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: GeneralEventTracker(
            controller: eventController,
            child: SnackbarParentView(
              controller: snackbarController,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(AppDimens.l, AppDimens.l, AppDimens.l, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      color: AppColors.black,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        eventController.track(AnalyticsEvent.subscriptionPageDismissed());
                        context.popRoute();
                      },
                    ),
                    Expanded(
                      child: InformedAnimatedSwitcher(
                        child: state.maybeMap(
                          initializing: (_) => const _SubscriptionPlansLoadingView(),
                          orElse: () => _SubscriptionPlansView(
                            cubit: cubit,
                            openInBrowser: _openInBrowser,
                            trialViewMode: cubit.plans.every((element) => element.hasTrial),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
