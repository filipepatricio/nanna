import 'package:better_informed_mobile/domain/purchases/data/subscription_plan.dart';
import 'package:better_informed_mobile/domain/purchases/use_case/get_preferred_subscription_plan_use_case.di.dart';
import 'package:better_informed_mobile/domain/purchases/use_case/get_subscription_plans_use_case.di.dart';
import 'package:better_informed_mobile/domain/purchases/use_case/purchase_subscription_use_case.di.dart';
import 'package:better_informed_mobile/domain/purchases/use_case/restore_purchase_use_case.di.dart';
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
  ) : super(SubscriptionPageState.initializing());

  final GetSubscriptionPlansUseCase _getSubscriptionPlansUseCase;
  final GetPreferredSubscriptionPlanUseCase _getPreferredSubscriptionPlanUseCase;
  final RestorePurchaseUseCase _restorePurchaseUseCase;
  final PurchaseSubscriptionUseCase _purchaseSubscriptionUseCase;

  late List<SubscriptionPlan> plans;
  late SubscriptionPlan selectedPlan;

  Future<void> initialize() async {
    plans = await _getSubscriptionPlansUseCase();

    if (plans.isNotEmpty) {
      selectedPlan = _getPreferredSubscriptionPlanUseCase.call(plans);
    }

    emit(SubscriptionPageState.idle());
  }

  void selectPlan(SubscriptionPlan plan) {
    if (selectedPlan != plan) {
      selectedPlan = plan;
      emit(SubscriptionPageState.idle());
    }
  }

  Future<void> purchase() async {
    emit(SubscriptionPageState.processing());
    try {
      final successful = await _purchaseSubscriptionUseCase.call(selectedPlan);
      if (!successful) {
        emit(SubscriptionPageState.idle());
        return;
      }
      emit(SubscriptionPageState.success());
    } catch (e) {
      Fimber.e('Error while trying to purchase package ${selectedPlan.packageId}', ex: e);
      emit(SubscriptionPageState.generalError());
    }
  }

  Future<void> restorePurchase() async {
    try {
      final successful = await _restorePurchaseUseCase();
      if (!successful) {
        emit(SubscriptionPageState.idle());
        return;
      }
      emit(SubscriptionPageState.success());
    } catch (e) {
      Fimber.e('Error while trying to restore purchase', ex: e);
      emit(SubscriptionPageState.generalError());
    }
  }
}
