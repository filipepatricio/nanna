import 'package:better_informed_mobile/domain/subscription/data/active_subscription.dt.dart';
import 'package:better_informed_mobile/domain/subscription/exception/purchase_exception.dart';
import 'package:better_informed_mobile/domain/subscription/purchases_repository.dart';
import 'package:better_informed_mobile/domain/subscription/subscription_local_repository.dart';
import 'package:better_informed_mobile/domain/util/network_cache_manager.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetActiveSubscriptionUseCase {
  GetActiveSubscriptionUseCase(
    this._purchasesRepository,
    this._networkCacheManager,
    this._subscriptionLocalRepository,
  );

  final PurchasesRepository _purchasesRepository;
  final NetworkCacheManager _networkCacheManager;
  final SubscriptionLocalRepository _subscriptionLocalRepository;

  Future<ActiveSubscription> call() async {
    try {
      final activeSubscription = await _purchasesRepository.getActiveSubscription();
      await _subscriptionLocalRepository.saveActiveSubscription(activeSubscription);

      return activeSubscription;
    } on PurchaseNetworkException {
      final storedSubscription = await _subscriptionLocalRepository.loadActiveSubscription();
      if (storedSubscription == null) rethrow;

      return storedSubscription;
    }
  }

  Stream<ActiveSubscription> get stream {
    return _purchasesRepository.activeSubscriptionStream.asyncMap((notification) async {
      await _networkCacheManager.clear();
      await _subscriptionLocalRepository.saveActiveSubscription(notification);
      return notification;
    });
  }
}
