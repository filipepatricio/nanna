import 'package:better_informed_mobile/domain/subscription/purchases_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ForceSubscriptionStatusSyncUseCase {
  ForceSubscriptionStatusSyncUseCase(this._purchasesRepository);

  final PurchasesRepository _purchasesRepository;

  Future<bool> call() async => await _purchasesRepository.forceSubscriptionStatusSync();
}
