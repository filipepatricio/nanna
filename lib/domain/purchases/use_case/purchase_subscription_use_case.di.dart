import 'package:better_informed_mobile/domain/purchases/data/subscription_plan.dart';
import 'package:better_informed_mobile/domain/purchases/purchases_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class PurchaseSubscriptionUseCase {
  PurchaseSubscriptionUseCase(this._purchasesRepository);

  final PurchasesRepository _purchasesRepository;

  Future<bool> call(SubscriptionPlan plan) async => await _purchasesRepository.purchase(plan);
}
