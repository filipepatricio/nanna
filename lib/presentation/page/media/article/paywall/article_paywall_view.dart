import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/subscription/subscription_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/subscription/subscription_page_state.dt.dart';
import 'package:better_informed_mobile/presentation/page/subscription/widgets/subscription_plans_loading_view.dart';
import 'package:better_informed_mobile/presentation/page/subscription/widgets/subscription_plans_view.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/snackbar_util.dart';
import 'package:better_informed_mobile/presentation/widget/informed_dialog.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

part 'widgets/paywall_background_fade.dart';

class ArticlePaywallView extends HookWidget {
  const ArticlePaywallView({
    required this.article,
    required this.child,
    super.key,
  });

  final Article article;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<SubscriptionPageCubit>();
    final state = useCubitBuilder<SubscriptionPageCubit, SubscriptionPageState>(cubit);
    final snackbarController = useSnackbarController();
    final shouldRestorePurchase = useValueNotifier(false);

    useOnAppLifecycleStateChange((previous, current) {
      if (current == AppLifecycleState.resumed && shouldRestorePurchase.value) {
        cubit.restorePurchase();
        shouldRestorePurchase.value = false;
      }
    });

    useCubitListener<SubscriptionPageCubit, SubscriptionPageState>(cubit, (cubit, state, context) {
      state.whenOrNull(
        idle: (_, __, ___) {
          InformedDialog.removeRestorePurchase(context);
        },
        restoringPurchase: () => InformedDialog.showRestorePurchase(context),
        success: () => InformedDialog.removeRestorePurchase(context),
        redeemingCode: () => shouldRestorePurchase.value = true,
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

    useEffect(
      () {
        cubit.initialize();
      },
      [cubit],
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Stack(
          children: [
            child,
            if (state.showPaywall(article.metadata.availableInSubscription))
              const Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _PaywallBackgroundFade(),
              ),
          ],
        ),
        if (state.showPaywall(article.metadata.availableInSubscription)) ...[
          const SizedBox(height: AppDimens.xl),
          state.maybeMap(
            idle: (state) => SubscriptionPlansView(
              cubit: cubit,
              trialViewMode: state.group.hasTrial,
              planGroup: state.group,
              selectedPlan: state.selectedPlan,
              isArticlePaywall: true,
            ),
            processing: (state) => SubscriptionPlansView(
              cubit: cubit,
              trialViewMode: state.group.hasTrial,
              planGroup: state.group,
              selectedPlan: state.selectedPlan,
              isArticlePaywall: true,
            ),
            orElse: () => const SubscriptionPlansLoadingView(),
          ),
        ],
      ],
    );
  }
}

extension on SubscriptionPageState {
  bool showPaywall(bool availableInSubscription) {
    return maybeMap(
      idle: (_) => !availableInSubscription,
      processing: (_) => !availableInSubscription,
      orElse: () => false,
    );
  }
}
