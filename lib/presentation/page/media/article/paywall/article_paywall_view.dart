import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/media/article/paywall/article_paywall_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/media/article/paywall/article_paywall_state.dt.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/in_app_browser.dart';
import 'package:better_informed_mobile/presentation/util/iterable_utils.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/link_label.dart';
import 'package:better_informed_mobile/presentation/widget/loading_shimmer.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_message.dt.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:better_informed_mobile/presentation/widget/subscription/subscribe_button.dart';
import 'package:better_informed_mobile/presentation/widget/subscription/subscription_plan_card.dart';
import 'package:better_informed_mobile/presentation/widget/subscription/subscrption_links_footer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

part 'widgets/paywall_background_fade.dart';
part 'widgets/paywall_multiple_options.dart';
part 'widgets/paywall_trial_option.dart';
part 'widgets/paywall_loading_view.dart';

class ArticlePaywallView extends HookWidget {
  const ArticlePaywallView({
    required this.article,
    required this.snackbarController,
    required this.child,
    super.key,
  });

  final Article article;
  final SnackbarController snackbarController;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<ArticlePaywallCubit>();
    final state = useCubitBuilder(cubit);

    useCubitListener<ArticlePaywallCubit, ArticlePaywallState>(cubit, (cubit, state, context) {
      state.mapOrNull(
        generalError: (_) {
          snackbarController.showMessage(
            SnackbarMessage.simple(
              message: LocaleKeys.common_error_tryAgainLater.tr(),
              type: SnackbarMessageType.negative,
            ),
          );
        },
      );
    });

    useEffect(
      () {
        cubit.initialize(article);
      },
      [cubit, article.metadata.availableInSubscription],
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Stack(
          children: [
            child,
            if (state.showPaywall)
              const Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _PaywallBackgroundFade(),
              ),
          ],
        ),
        if (state.showPaywall) ...[
          const SizedBox(height: AppDimens.c),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.m),
            child: state.maybeMap(
              trial: (state) => _PaywallTrialOption(
                plan: state.plan,
                onPurchasePressed: cubit.purchase,
                isProcessing: state.processing,
              ),
              multiplePlans: (state) => _PaywallMultipleOptions(
                plans: state.plans,
                snackbarController: snackbarController,
                onPurchasePressed: cubit.purchase,
                onRestorePressed: cubit.restore,
                isProcessing: state.processing,
              ),
              loading: (_) => const _PaywallLoadingView(),
              orElse: () => const SizedBox(),
            ),
          ),
        ],
      ],
    );
  }
}

extension on ArticlePaywallState {
  bool get showPaywall {
    return maybeMap(
      multiplePlans: (_) => true,
      trial: (_) => true,
      loading: (_) => true,
      orElse: () => false,
    );
  }
}
