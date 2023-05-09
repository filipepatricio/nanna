import 'package:better_informed_mobile/domain/auth/auth_store.dart';
import 'package:better_informed_mobile/domain/subscription/purchases_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class InitializePurchasesUseCase {
  const InitializePurchasesUseCase(
    this._authStore,
    this._purchasesRepository,
  );

  final AuthStore _authStore;
  final PurchasesRepository _purchasesRepository;

  Future<void> call() async {
    final tokenData = await _authStore.accessTokenData();

    await _purchasesRepository.initialize(tokenData?.uuid);
  }
}
