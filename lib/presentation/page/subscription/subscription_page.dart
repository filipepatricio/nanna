import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/subscription/subscription_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/subscription/subscription_page_state.dt.dart';
import 'package:better_informed_mobile/presentation/page/subscription/widgets/subscription_plans_loading_view.dart';
import 'package:better_informed_mobile/presentation/page/subscription/widgets/subscription_plans_view.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/informed_animated_switcher.dart';
import 'package:better_informed_mobile/presentation/widget/informed_dialog.dart';
import 'package:better_informed_mobile/presentation/widget/modal_bottom_sheet.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_message.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:better_informed_mobile/presentation/widget/track/general_event_tracker/general_event_tracker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SubscriptionPage extends HookWidget {
  const SubscriptionPage();

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<SubscriptionPageCubit>();
    final state = useCubitBuilder<SubscriptionPageCubit, SubscriptionPageState>(cubit);
    final snackbarController = useMemoized(() => SnackbarController());
    final eventController = useEventTrackingController();
    final shouldRestorePurchase = useValueNotifier(false);

    useEffect(
      () {
        cubit.initialize();
      },
      [cubit],
    );

    useOnAppLifecycleStateChange((previous, current) {
      if (current == AppLifecycleState.resumed && shouldRestorePurchase.value) {
        cubit.restorePurchase();
        shouldRestorePurchase.value = false;
      }
    });

    useCubitListener<SubscriptionPageCubit, SubscriptionPageState>(cubit, (cubit, state, context) {
      state.whenOrNull(
        idle: (_, __, ___, ____) => InformedDialog.removeRestorePurchase(context),
        restoringPurchase: () => InformedDialog.showRestorePurchase(context),
        redeemingCode: () => shouldRestorePurchase.value = true,
        success: () {
          InformedDialog.removeRestorePurchase(context);
          context.popRoute();
        },
        successGuest: context.resetToEntry,
        generalError: () => snackbarController.showMessage(SnackbarMessage.error(context)),
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
              trialViewMode: state.group.hasTrial,
              planGroup: state.group,
              selectedPlan: state.selectedPlan,
            ),
            processing: (state) => SubscriptionPlansView(
              cubit: cubit,
              trialViewMode: state.group.hasTrial,
              planGroup: state.group,
              selectedPlan: state.selectedPlan,
            ),
            orElse: () => const SubscriptionPlansLoadingView(),
          ),
        ),
      ),
    );
  }
}
