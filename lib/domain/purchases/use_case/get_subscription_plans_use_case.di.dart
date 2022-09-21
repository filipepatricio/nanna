import 'package:better_informed_mobile/domain/purchases/data/subscription_plan.dart';
import 'package:better_informed_mobile/domain/purchases/purchases_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetSubscriptionPlansUseCase {
  GetSubscriptionPlansUseCase(this._purchasesRepository);

  final PurchasesRepository _purchasesRepository;

  Future<List<SubscriptionPlan>> call() async => await _purchasesRepository.getSubscriptionPlans();
}
