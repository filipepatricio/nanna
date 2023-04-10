import 'package:better_informed_mobile/core/util/app_link.dart';
import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_article_paywall_preferred_plan_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/purchase_subscription_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/restore_purchase_use_case.di.dart';
import 'package:better_informed_mobile/presentation/page/media/article/paywall/article_paywall_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';

@injectable
class ArticlePaywallCubit extends Cubit<ArticlePaywallState> {
  ArticlePaywallCubit(
    this._getArticlePaywallPreferredPlanUseCase,
    this._restorePurchaseUseCase,
    this._purchaseSubscriptionUseCase,
  ) : super(const ArticlePaywallState.initializing());

  final GetArticlePaywallPreferredPlanUseCase _getArticlePaywallPreferredPlanUseCase;
  final RestorePurchaseUseCase _restorePurchaseUseCase;
  final PurchaseSubscriptionUseCase _purchaseSubscriptionUseCase;

  Future<void> initialize(Article article) async {
    if (article.metadata.availableInSubscription) {
      emit(const ArticlePaywallState.disabled());
      return;
    }

    emit(const ArticlePaywallState.loading());
    await _setupPaywall();
  }

  Future<void> purchase(SubscriptionPlan plan) async {
    _emitProcessingState(true);

    try {
      final result = await _purchaseSubscriptionUseCase(plan);

      if (result) {
        emit(const ArticlePaywallState.purchaseSuccess());
        emit(const ArticlePaywallState.loading());
      } else {
        await _setupPaywall();
      }
    } catch (e, s) {
      Fimber.e(
        'Error while trying to purchase package ${plan.packageId}',
        ex: e,
        stacktrace: s,
      );
      emit(const ArticlePaywallState.generalError());
    }
  }

  Future<void> restorePurchase() async {
    try {
      emit(const ArticlePaywallState.restoringPurchase());
      final successful = await _restorePurchaseUseCase();

      if (successful) {
        emit(const ArticlePaywallState.purchaseSuccess());
      } else {
        await _setupPaywall();
      }
    } catch (e, s) {
      Fimber.e(
        'Error while trying to restore purchase',
        ex: e,
        stacktrace: s,
      );
      emit(const ArticlePaywallState.restoringPurchaseError());
    }
  }

  Future<void> redeemOfferCode() async {
    emit(const ArticlePaywallState.redeemingCode());
    await openUrlWithAnyApp(
      appleCodeRedemptionLink,
      (error, stackTrace) => Fimber.e('Error launching code redemption sheet', ex: error, stacktrace: stackTrace),
    );
  }

  Future<void> _setupPaywall() async {
    final planPack = await _getArticlePaywallPreferredPlanUseCase();

    final state = planPack.map(
      singleTrial: (pack) => ArticlePaywallState.trial(pack.plan, false),
      multiple: (pack) => ArticlePaywallState.multiplePlans(pack.planGroup, false),
    );

    emit(state);
  }

  void _emitProcessingState(bool processing) {
    final newState = state.maybeMap(
      trial: (state) => state.copyWith(processing: processing),
      multiplePlans: (state) => state.copyWith(processing: processing),
      orElse: () => state,
    );

    emit(newState);
  }
}
