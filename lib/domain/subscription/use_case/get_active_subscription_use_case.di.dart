import 'package:better_informed_mobile/domain/subscription/data/active_subscription.dt.dart';
import 'package:better_informed_mobile/domain/subscription/purchases_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetActiveSubscriptionUseCase {
  GetActiveSubscriptionUseCase(this._purchasesRepository);

  final PurchasesRepository _purchasesRepository;

  Future<ActiveSubscription> call() async => await _purchasesRepository.getActiveSubscription();

  Stream<ActiveSubscription> get stream => _purchasesRepository.activeSubscriptionStream;
}
