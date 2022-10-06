import 'package:better_informed_mobile/domain/subscription/data/active_subscription.dt.dart';
import 'package:better_informed_mobile/domain/subscription/purchases_repository.dart';
import 'package:better_informed_mobile/domain/util/network_cache_manager.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetActiveSubscriptionUseCase {
  GetActiveSubscriptionUseCase(
    this._purchasesRepository,
    this._networkCacheManager,
  );

  final PurchasesRepository _purchasesRepository;
  final NetworkCacheManager _networkCacheManager;

  Future<ActiveSubscription> call() async => await _purchasesRepository.getActiveSubscription();

  Stream<ActiveSubscription> get stream {
    return _purchasesRepository.activeSubscriptionStream.asyncMap((notification) async {
      await _networkCacheManager.clear();
      return notification;
    });
  }
}
