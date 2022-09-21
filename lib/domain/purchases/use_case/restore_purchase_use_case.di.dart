import 'package:better_informed_mobile/domain/purchases/purchases_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class RestorePurchaseUseCase {
  RestorePurchaseUseCase(this._purchasesRepository);

  final PurchasesRepository _purchasesRepository;

  Future<bool> call() async => await _purchasesRepository.retorePurchase();
}
