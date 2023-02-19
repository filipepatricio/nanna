import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_plan_group.dt.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_preferred_subscription_plan_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_subscription_plans_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/purchase_subscription_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/redeem_offer_code_use_case.di.dart';
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
    this._redeemOfferCodeUseCase,
  ) : super(const SubscriptionPageState.initializing());

  final GetSubscriptionPlansUseCase _getSubscriptionPlansUseCase;
  final GetPreferredSubscriptionPlanUseCase _getPreferredSubscriptionPlanUseCase;
  final RestorePurchaseUseCase _restorePurchaseUseCase;
  final PurchaseSubscriptionUseCase _purchaseSubscriptionUseCase;
  final RedeemOfferCodeUseCase _redeemOfferCodeUseCase;

  late SubscriptionPlanGroup _planGroup;
  late SubscriptionPlan _selectedPlan;

  Future<void> initialize() async {
    try {
      _planGroup = await _getSubscriptionPlansUseCase();

      if (_planGroup.plans.isNotEmpty) {
        _selectedPlan = _getPreferredSubscriptionPlanUseCase.call(_planGroup.plans);
      }

      emit(SubscriptionPageState.idle(group: _planGroup, selectedPlan: _selectedPlan));
    } catch (e) {
      Fimber.e('Error while trying to load available subscription plans', ex: e);
      emit(const SubscriptionPageState.generalError());
    }
  }

  void selectPlan(SubscriptionPlan plan) {
    if (_selectedPlan != plan) {
      _selectedPlan = plan;
      emit(SubscriptionPageState.idle(group: _planGroup, selectedPlan: _selectedPlan));
    }
  }

  Future<void> purchase() async {
    emit(SubscriptionPageState.processing(group: _planGroup, selectedPlan: _selectedPlan));

    try {
      final successful = await _purchaseSubscriptionUseCase.call(_selectedPlan);
      if (!successful) {
        emit(SubscriptionPageState.idle(group: _planGroup, selectedPlan: _selectedPlan));
        return;
      }
      emit(SubscriptionPageState.success(withTrial: _selectedPlan.hasTrial));
    } catch (e) {
      Fimber.e('Error while trying to purchase package ${_selectedPlan.packageId}', ex: e);
      emit(const SubscriptionPageState.generalError());
      emit(SubscriptionPageState.idle(group: _planGroup, selectedPlan: _selectedPlan));
    }
  }

  Future<void> restorePurchase() async {
    try {
      emit(const SubscriptionPageState.restoringPurchase());
      final successful = await _restorePurchaseUseCase();
      if (!successful) {
        emit(SubscriptionPageState.idle(group: _planGroup, selectedPlan: _selectedPlan));
        return;
      }
      emit(SubscriptionPageState.success(withTrial: _selectedPlan.hasTrial));
    } catch (e) {
      Fimber.e('Error while trying to restore purchase', ex: e);
      emit(SubscriptionPageState.generalError(LocaleKeys.subscription_restoringPurchaseError.tr()));
      emit(SubscriptionPageState.idle(group: _planGroup, selectedPlan: _selectedPlan));
    }
  }

  Future<void> redeemOfferCode() async => await _redeemOfferCodeUseCase();
}
