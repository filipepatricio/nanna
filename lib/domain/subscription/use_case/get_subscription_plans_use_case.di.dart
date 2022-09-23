import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';
import 'package:better_informed_mobile/domain/subscription/purchases_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetSubscriptionPlansUseCase {
  GetSubscriptionPlansUseCase(this._purchasesRepository);

  final PurchasesRepository _purchasesRepository;

  Future<List<SubscriptionPlan>> call() async => await _purchasesRepository.getSubscriptionPlans();
}
