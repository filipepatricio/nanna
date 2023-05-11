import 'package:better_informed_mobile/core/util/app_link.dart';
import 'package:better_informed_mobile/domain/auth/use_case/is_signed_in_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/data/active_subscription.dt.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_plan_group.dt.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_active_subscription_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_preferred_subscription_plan_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_subscription_plans_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/purchase_subscription_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/restore_purchase_use_case.di.dart';
import 'package:better_informed_mobile/presentation/page/subscription/subscription_page_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';

@injectable
class SubscriptionPageCubit extends Cubit<SubscriptionPageState> {
  SubscriptionPageCubit(
    this._getSubscriptionPlansUseCase,
    this._getPreferredSubscriptionPlanUseCase,
    this._restorePurchaseUseCase,
    this._purchaseSubscriptionUseCase,
    this._getActiveSubscriptionUseCase,
    this._isSignedInUseCase,
  ) : super(const SubscriptionPageState.initializing());

  final GetSubscriptionPlansUseCase _getSubscriptionPlansUseCase;
  final GetPreferredSubscriptionPlanUseCase _getPreferredSubscriptionPlanUseCase;
  final RestorePurchaseUseCase _restorePurchaseUseCase;
  final PurchaseSubscriptionUseCase _purchaseSubscriptionUseCase;
  final GetActiveSubscriptionUseCase _getActiveSubscriptionUseCase;
  final IsSignedInUseCase _isSignedInUseCase;

  late SubscriptionPlanGroup _planGroup;
  late SubscriptionPlan _selectedPlan;
  late ActiveSubscription _subscription;

  late bool _isSignedIn;

  SubscriptionPlan? get currentPlan => _subscription.mapOrNull(
        trial: (data) => data.plan,
        premium: (data) => data.plan,
      );

  SubscriptionPlan? get nextPlan => _subscription.mapOrNull<SubscriptionPlan?>(
        trial: (data) => data.nextPlan,
        premium: (data) => data.nextPlan,
      );

  Future<void> initialize() async {
    try {
      _isSignedIn = await _isSignedInUseCase();
      _planGroup = await _getSubscriptionPlansUseCase();
      _subscription = await _getActiveSubscriptionUseCase();

      if (_planGroup.plans.isNotEmpty) {
        _selectedPlan = _getPreferredSubscriptionPlanUseCase.call(_planGroup.plans, currentPlan: currentPlan);
      }

      _emitIdleState();
    } catch (e) {
      Fimber.e('Error while trying to load available subscription plans', ex: e);
      emit(const SubscriptionPageState.generalError());
    }
  }

  void selectPlan(SubscriptionPlan plan) {
    if (_selectedPlan != plan) {
      _selectedPlan = plan;
      _emitIdleState();
    }
  }

  void _emitIdleState() {
    if (!isClosed) {
      emit(
        SubscriptionPageState.idle(
          group: _planGroup,
          selectedPlan: _selectedPlan,
          subscription: _subscription,
          isGuest: !_isSignedIn,
        ),
      );
    }
  }

  Future<void> purchase() async {
    emit(
      SubscriptionPageState.processing(
        group: _planGroup,
        selectedPlan: _selectedPlan,
        subscription: _subscription,
        isGuest: !_isSignedIn,
      ),
    );

    try {
      final successful = await _purchaseSubscriptionUseCase.call(_selectedPlan);
      if (!successful) {
        _emitIdleState();
        return;
      }
      emit(const SubscriptionPageState.success());
    } catch (e) {
      Fimber.e('Error while trying to purchase package ${_selectedPlan.packageId}', ex: e);
      emit(const SubscriptionPageState.generalError());
      _emitIdleState();
    }
  }

  Future<void> restorePurchase() async {
    try {
      emit(const SubscriptionPageState.restoringPurchase());
      final successful = await _restorePurchaseUseCase();
      if (!successful) {
        _emitIdleState();
        return;
      }
      emit(const SubscriptionPageState.success());
    } catch (e) {
      Fimber.e('Error while trying to restore purchase', ex: e);
      emit(const SubscriptionPageState.restoringPurchaseError());
      _emitIdleState();
    }
  }

  Future<void> redeemOfferCode() async {
    emit(const SubscriptionPageState.redeemingCode());
    await openUrlWithAnyApp(
      appleCodeRedemptionLink,
      (error, stackTrace) => Fimber.e('Error launching code redemption sheet', ex: error, stacktrace: stackTrace),
    );
  }
}
