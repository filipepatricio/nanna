import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/article/data/article.dart';
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
import 'package:better_informed_mobile/presentation/widget/subscription/subscribe_button.dart';
import 'package:better_informed_mobile/presentation/widget/subscription/subscription_plan_card.dart';
import 'package:better_informed_mobile/presentation/widget/subscription/subscrption_links_footer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

part 'widgets/paywall_background_fade.dart';
part 'widgets/paywall_multiple_options.dart';
part 'widgets/paywall_trial_option.dart';

typedef OnPurchasePressed = void Function(SubscriptionPlan plan);
typedef OnPurchaseSuccess = void Function();
typedef OnGeneralError = void Function();

class ArticlePaywallView extends HookWidget {
  const ArticlePaywallView({
    required this.article,
    required this.onPurchaseSuccess,
    required this.onGeneralError,
    required this.child,
    super.key,
  });

  final Article article;
  final OnPurchaseSuccess onPurchaseSuccess;
  final OnGeneralError onGeneralError;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<ArticlePaywallCubit>();
    final state = useCubitBuilder(cubit);

    useCubitListener<ArticlePaywallCubit, ArticlePaywallState>(cubit, (cubit, state, context) {
      state.mapOrNull(
        purchaseSuccess: (_) => onPurchaseSuccess(),
      );
    });

    useEffect(
      () {
        cubit.initialize(article);
      },
      [cubit, article],
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Stack(
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: _backgroundFadeHeight,
                minWidth: double.infinity,
              ),
              child: child,
            ),
            if (state.showPaywall)
              const Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _PaywallBackgroundFade(),
              ),
          ],
        ),
        if (state.showPaywall)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
            child: state.maybeMap(
              trial: (state) => _PaywallTrialOption(
                plan: state.plan,
                onPurchasePressed: cubit.purchase,
                isProcessing: state.processing,
              ),
              multiplePlans: (state) => _PaywallMultipleOptions(
                plans: state.plans,
                onPurchasePressed: cubit.purchase,
                onRestorePressed: cubit.restore,
                isProcessing: state.processing,
              ),
              orElse: () => const SizedBox(),
            ),
          ),
      ],
    );
  }
}

extension on ArticlePaywallState {
  bool get showPaywall {
    return maybeMap(
      multiplePlans: (_) => true,
      trial: (_) => true,
      orElse: () => false,
    );
  }
}
