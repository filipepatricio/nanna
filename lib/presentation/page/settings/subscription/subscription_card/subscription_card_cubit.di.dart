import 'dart:async';

import 'package:better_informed_mobile/domain/subscription/data/active_subscription.dt.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_active_subscription_use_case.di.dart';
import 'package:better_informed_mobile/presentation/page/settings/subscription/subscription_card/subscription_card_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SubscriptionCardCubit extends Cubit<SubscriptionCardState> {
  SubscriptionCardCubit(this._getActiveSubscriptionUseCase) : super(const SubscriptionCardState.loading());

  final GetActiveSubscriptionUseCase _getActiveSubscriptionUseCase;

  StreamSubscription? _activeSubscriptionStreamSubscription;

  Future<void> initialize() async {
    _emitIdleState(await _getActiveSubscriptionUseCase());

    _activeSubscriptionStreamSubscription = _getActiveSubscriptionUseCase.stream.listen(_emitIdleState);
  }

  void _emitIdleState(ActiveSubscription activeSubscription) {
    emit(
      activeSubscription.map<SubscriptionCardState>(
        free: (_) => const SubscriptionCardState.free(),
        trial: (subscription) => SubscriptionCardState.trial(remainingDays: subscription.remainingTrialDays),
        premium: (_) => const SubscriptionCardState.premium(),
      ),
    );
  }

  @override
  Future<void> close() async {
    await _activeSubscriptionStreamSubscription?.cancel();
    await super.close();
  }
}
