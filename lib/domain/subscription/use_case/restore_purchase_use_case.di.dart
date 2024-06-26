import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_repository.dart';
import 'package:better_informed_mobile/domain/subscription/purchases_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class RestorePurchaseUseCase {
  RestorePurchaseUseCase(
    this._purchasesRepository,
    this._analyticsRepository,
  );

  final PurchasesRepository _purchasesRepository;
  final AnalyticsRepository _analyticsRepository;

  Future<bool> call() async {
    final result = await _purchasesRepository.restorePurchase();
    if (result) _analyticsRepository.event(AnalyticsEvent.purchaseRestored());
    return result;
  }
}
