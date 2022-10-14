import 'package:better_informed_mobile/domain/subscription/purchases_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class PrecacheSubscriptionPlansUseCase {
  PrecacheSubscriptionPlansUseCase(
    this._purchasesRepository,
  );

  final PurchasesRepository _purchasesRepository;

  Future<void> call() async => _purchasesRepository.precacheSubscriptionPlans();
}
