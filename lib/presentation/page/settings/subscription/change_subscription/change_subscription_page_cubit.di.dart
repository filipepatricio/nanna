import 'package:better_informed_mobile/domain/subscription/data/active_subscription.dt.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_active_subscription_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_subscription_plans_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/purchase_subscription_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/restore_purchase_use_case.di.dart';
import 'package:better_informed_mobile/presentation/page/settings/subscription/change_subscription/change_subscription_page_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';

@injectable
class ChangeSubscriptionPageCubit extends Cubit<ChangeSubscriptionPageState> {
  ChangeSubscriptionPageCubit(
    this._getSubscriptionPlansUseCase,
    this._getActiveSubscriptionUseCase,
    this._restorePurchaseUseCase,
    this._purchaseSubscriptionUseCase,
  ) : super(const ChangeSubscriptionPageState.initializing());

  final GetSubscriptionPlansUseCase _getSubscriptionPlansUseCase;
  final GetActiveSubscriptionUseCase _getActiveSubscriptionUseCase;
  final RestorePurchaseUseCase _restorePurchaseUseCase;
  final PurchaseSubscriptionUseCase _purchaseSubscriptionUseCase;

  late List<SubscriptionPlan> _plans;
  late ActiveSubscription _subscription;

  late SubscriptionPlan? currentPlan;
  SubscriptionPlan? selectedPlan;

  Future<void> initialize() async {
    _plans = await _getSubscriptionPlansUseCase();
    _subscription = await _getActiveSubscriptionUseCase();
    currentPlan = _subscription.mapOrNull(
      trial: (data) => data.plan,
      premium: (data) => data.plan,
    );

    if (currentPlan != null) selectedPlan = currentPlan!;

    _emitIdle();
  }

  void selectPlan(SubscriptionPlan plan) {
    if (selectedPlan != plan) {
      selectedPlan = plan;
      _emitIdle();
    }
  }

  Future<void> purchase() async {
    emit(ChangeSubscriptionPageState.processing(plans: _plans, subscription: _subscription));
    try {
      final successful = await _purchaseSubscriptionUseCase.call(selectedPlan!);
      if (!successful) {
        _emitIdle();
        return;
      }
      emit(ChangeSubscriptionPageState.success());
    } catch (e) {
      Fimber.e('Error while trying to purchase package ${selectedPlan!.packageId}', ex: e);
      emit(ChangeSubscriptionPageState.generalError());
      _emitIdle();
    }
  }

  Future<void> restorePurchase() async {
    try {
      final successful = await _restorePurchaseUseCase();
      if (!successful) {
        _emitIdle();
        return;
      }
      emit(ChangeSubscriptionPageState.success());
    } catch (e) {
      Fimber.e('Error while trying to restore purchase', ex: e);
      emit(ChangeSubscriptionPageState.generalError());
      _emitIdle();
    }
  }

  void _emitIdle() {
    emit(ChangeSubscriptionPageState.idle(plans: _plans, subscription: _subscription));
  }
}
