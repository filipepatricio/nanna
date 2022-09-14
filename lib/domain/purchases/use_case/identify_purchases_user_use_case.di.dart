import 'package:better_informed_mobile/domain/auth/auth_store.dart';
import 'package:better_informed_mobile/domain/purchases/purchases_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class IdentifyPurchasesUserUseCase {
  IdentifyPurchasesUserUseCase(
    this._authStore,
    this._purchasesRepository,
  );
  final AuthStore _authStore;
  final PurchasesRepository _purchasesRepository;

  Future<void> call() async {
    final tokenData = await _authStore.accessTokenData();

    if (tokenData != null) {
      await _purchasesRepository.identify(tokenData.uuid);
    }
  }
}
