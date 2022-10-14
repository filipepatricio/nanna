import 'dart:async';

import 'package:better_informed_mobile/domain/subscription/data/active_subscription.dt.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_active_subscription_use_case.di.dart';
import 'package:better_informed_mobile/presentation/page/settings/subscription/settings_subscription_page_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class SettingsSubscriptionPageCubit extends Cubit<SettingsSubscriptionPageState> {
  SettingsSubscriptionPageCubit(this._getActiveSubscriptionUseCase) : super(const SettingsSubscriptionPageState.init());

  final GetActiveSubscriptionUseCase _getActiveSubscriptionUseCase;

  StreamSubscription? _activeSubscriptionStreamSubscription;

  Future<void> initialize() async {
    emit(const SettingsSubscriptionPageState.loading());

    _emitIdleState(await _getActiveSubscriptionUseCase());

    _activeSubscriptionStreamSubscription = _getActiveSubscriptionUseCase.stream.listen(_emitIdleState);
  }

  void _emitIdleState(ActiveSubscription activeSubscription) {
    activeSubscription.mapOrNull(
      trial: (subscription) {
        emit(SettingsSubscriptionPageState.trial(subscription: subscription));
      },
      premium: (subscription) {
        emit(SettingsSubscriptionPageState.premium(subscription: subscription));
      },
      manualPremium: (subscription) {
        emit(SettingsSubscriptionPageState.manualPremium(subscription: subscription));
      },
    );
  }

  @override
  Future<void> close() async {
    await _activeSubscriptionStreamSubscription?.cancel();
    await super.close();
  }
}
