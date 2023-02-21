import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_plan_group.dt.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/subscription/subscription_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/subscription/subscription_page_state.dt.dart';
import 'package:better_informed_mobile/presentation/page/subscription/widgets/subscription_benefits.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/in_app_browser.dart';
import 'package:better_informed_mobile/presentation/util/iterable_utils.dart';
import 'package:better_informed_mobile/presentation/util/platform_util.dart';
import 'package:better_informed_mobile/presentation/widget/informed_animated_switcher.dart';
import 'package:better_informed_mobile/presentation/widget/informed_dialog.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/link_label.dart';
import 'package:better_informed_mobile/presentation/widget/loading_shimmer.dart';
import 'package:better_informed_mobile/presentation/widget/modal_bottom_sheet.dart';
import 'package:better_informed_mobile/presentation/widget/physics/platform_scroll_physics.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_message.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:better_informed_mobile/presentation/widget/subscription/subscribe_button.dart';
import 'package:better_informed_mobile/presentation/widget/subscription/subscription_plan_card.dart';
import 'package:better_informed_mobile/presentation/widget/subscription/subscrption_links_footer.dart';
import 'package:better_informed_mobile/presentation/widget/track/general_event_tracker/general_event_tracker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

part 'widgets/subscription_plans_loading_view.dart';
part 'widgets/subscription_plans_view.dart';

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
        idle: (group, selectedPlan) {
          InformedDialog.removeRestorePurchase(context);
        },
        restoringPurchase: () => InformedDialog.showRestorePurchase(context),
        success: (trialMode) {
          InformedDialog.removeRestorePurchase(context);
          AutoRouter.of(context).replace(
            SubscriptionSuccessPageRoute(trialMode: trialMode),
          );
        },
        generalError: (message) {
          snackbarController.showMessage(
            SnackbarMessage.simple(
              message: message ?? context.l10n.common_error_tryAgainLater,
              type: SnackbarMessageType.error,
            ),
          );
        },
        restoringPurchaseError: () {
          InformedDialog.removeRestorePurchase(context);
          snackbarController.showMessage(
            SnackbarMessage.simple(
              message: context.l10n.subscription_restoringPurchaseError,
              type: SnackbarMessageType.error,
            ),
          );
        },
      );
    });

    Future<void> openInBrowser(BuildContext context, String uri) async {
      await openInAppBrowser(
        uri,
        (error, stacktrace) {
          showBrowserError(context, uri, snackbarController);
        },
      );
    }

    return GeneralEventTracker(
      controller: eventController,
      child: ModalBottomSheet(
        snackbarController: snackbarController,
        onClose: () => state.maybeMap(
          success: (_) {},
          orElse: () => eventController.track(AnalyticsEvent.subscriptionPageDismissed()),
        ),
        child: InformedAnimatedSwitcher(
          child: state.maybeMap(
            idle: (state) => SubscriptionPlansView(
              cubit: cubit,
              openInBrowser: (uri) => openInBrowser(context, uri),
              trialViewMode: state.group.hasTrail,
              planGroup: state.group,
              selectedPlan: state.selectedPlan,
            ),
            processing: (state) => SubscriptionPlansView(
              cubit: cubit,
              openInBrowser: (uri) => openInBrowser(context, uri),
              trialViewMode: state.group.hasTrail,
              planGroup: state.group,
              selectedPlan: state.selectedPlan,
            ),
            orElse: () => const _SubscriptionPlansLoadingView(),
          ),
        ),
      ),
    );
  }
}
