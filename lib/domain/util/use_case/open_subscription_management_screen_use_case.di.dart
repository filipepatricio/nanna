import 'package:better_informed_mobile/domain/subscription/use_case/get_active_subscription_use_case.di.dart';
import 'package:better_informed_mobile/domain/util/app_info_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class OpenSubscriptionManagementScreenUseCase {
  OpenSubscriptionManagementScreenUseCase(
    this._appInfoRepository,
    this._getActiveSubscriptionUseCase,
  );

  final AppInfoRepository _appInfoRepository;
  final GetActiveSubscriptionUseCase _getActiveSubscriptionUseCase;

  Future<void> call() async {
    final activeSubscription = await _getActiveSubscriptionUseCase();

    final sku = activeSubscription.map(
      free: (_) => null,
      trial: (sub) => sub.plan.productId,
      premium: (sub) => sub.plan.productId,
      manualPremium: (sub) => null,
    );

    await _appInfoRepository.openSubscriptionManagementSystemPage(sku);
  }
}
