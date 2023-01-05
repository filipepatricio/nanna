import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_preferred_subscription_plan_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_subscription_plans_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/purchase_subscription_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/restore_purchase_use_case.di.dart';
import 'package:better_informed_mobile/exports.dart';
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
  ) : super(const SubscriptionPageState.initializing());

  final GetSubscriptionPlansUseCase _getSubscriptionPlansUseCase;
  final GetPreferredSubscriptionPlanUseCase _getPreferredSubscriptionPlanUseCase;
  final RestorePurchaseUseCase _restorePurchaseUseCase;
  final PurchaseSubscriptionUseCase _purchaseSubscriptionUseCase;

  late List<SubscriptionPlan> plans;
  late SubscriptionPlan selectedPlan;

  Future<void> initialize() async {
    try {
      plans = await _getSubscriptionPlansUseCase();

      if (plans.isNotEmpty) {
        selectedPlan = _getPreferredSubscriptionPlanUseCase.call(plans);
      }

      emit(const SubscriptionPageState.idle());
    } catch (e) {
      Fimber.e('Error while trying to load available subscription plans', ex: e);
      emit(const SubscriptionPageState.generalError());
    }
  }

  void selectPlan(SubscriptionPlan plan) {
    if (selectedPlan != plan) {
      selectedPlan = plan;
      emit(const SubscriptionPageState.idle());
    }
  }

  Future<void> purchase() async {
    emit(const SubscriptionPageState.processing());
    try {
      final successful = await _purchaseSubscriptionUseCase.call(selectedPlan);
      if (!successful) {
        emit(const SubscriptionPageState.idle());
        return;
      }
      emit(SubscriptionPageState.success(withTrial: selectedPlan.hasTrial));
    } catch (e) {
      Fimber.e('Error while trying to purchase package ${selectedPlan.packageId}', ex: e);
      emit(const SubscriptionPageState.generalError());
      emit(const SubscriptionPageState.idle());
    }
  }

  Future<void> restorePurchase() async {
    try {
      emit(const SubscriptionPageState.restoringPurchase());
      final successful = await _restorePurchaseUseCase();
      if (!successful) {
        emit(const SubscriptionPageState.idle());
        return;
      }
      emit(SubscriptionPageState.success(withTrial: selectedPlan.hasTrial));
    } catch (e) {
      Fimber.e('Error while trying to restore purchase', ex: e);
      emit(SubscriptionPageState.generalError(LocaleKeys.subscription_restoringPurchaseError.tr()));
      emit(const SubscriptionPageState.idle());
    }
  }
}
