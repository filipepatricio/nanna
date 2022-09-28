import 'package:better_informed_mobile/domain/subscription/store/subscription_store.dart';
import 'package:better_informed_mobile/domain/user_store/user_store.dart';
import 'package:injectable/injectable.dart';

@injectable
class IsOnboardingPaywallSeenUseCase {
  IsOnboardingPaywallSeenUseCase(
    this._subscriptionStore,
    this._userStore,
  );
  final SubscriptionStore _subscriptionStore;
  final UserStore _userStore;

  Future<bool> call() async {
    final currentUserUuid = await _userStore.getCurrentUserUuid();
    return _subscriptionStore.isOnboardingPaywallSeen(currentUserUuid);
  }
}