import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/subscription/data/active_subscription.dt.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_plan_group.dt.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/settings/subscription/change_subscription/change_subscription_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/settings/subscription/change_subscription/change_subscription_page_state.dt.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/date_format_util.dart';
import 'package:better_informed_mobile/presentation/util/in_app_browser.dart';
import 'package:better_informed_mobile/presentation/util/iterable_utils.dart';
import 'package:better_informed_mobile/presentation/widget/filled_button.dart';
import 'package:better_informed_mobile/presentation/widget/informed_dialog.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/loading_shimmer.dart';
import 'package:better_informed_mobile/presentation/widget/modal_bottom_sheet.dart';
import 'package:better_informed_mobile/presentation/widget/physics/platform_scroll_physics.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_message.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:better_informed_mobile/presentation/widget/subscription/subscription_plan_card.dart';
import 'package:better_informed_mobile/presentation/widget/subscription/subscrption_links_footer.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

part './widgets/change_subscription_loading_view.dart';
part './widgets/change_subscription_plans_view.dart';

class ChangeSubscriptionPage extends HookWidget {
  const ChangeSubscriptionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<ChangeSubscriptionPageCubit>();
    final state = useCubitBuilder(cubit);
    final snackbarController = useMemoized(() => SnackbarController());

    useEffect(
      () {
        cubit.initialize();
      },
      [cubit],
    );

    useCubitListener<ChangeSubscriptionPageCubit, ChangeSubscriptionPageState>(cubit, (cubit, state, context) {
      state.whenOrNull(
        restoringPurchase: () => InformedDialog.showRestorePurchase(context),
        idle: (planGroup, subscription) => InformedDialog.removeRestorePurchase(context),
        success: () {
          InformedDialog.removeRestorePurchase(context);
          AutoRouter.of(context).replace(
            SubscriptionSuccessPageRoute(trialMode: false),
          );
        },
        generalError: (message) {
          InformedDialog.removeRestorePurchase(context);
          snackbarController.showMessage(
            SnackbarMessage.simple(
              message: message ?? LocaleKeys.common_error_tryAgainLater.tr(),
              type: SnackbarMessageType.error,
            ),
          );
        },
      );
    });

    Future<void> openInBrowser(String uri) async {
      await openInAppBrowser(
        uri,
        (error, stacktrace) {
          showBrowserError(uri, snackbarController);
        },
      );
    }

    return ModalBottomSheet(
      snackbarController: snackbarController,
      child: state.maybeWhen(
        initializing: () => const _ChangeSubscriptionLoadingView(),
        orElse: () => _ChangeSubscriptionPlansView(
          cubit: cubit,
          openInBrowser: openInBrowser,
        ),
      ),
    );
  }
}
