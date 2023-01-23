import 'package:better_informed_mobile/domain/analytics/analytics_repository.dart';
import 'package:better_informed_mobile/domain/feature_flags/feature_flags_repository.dart';
import 'package:better_informed_mobile/domain/subscription/purchases_repository.dart';
import 'package:better_informed_mobile/presentation/util/platform_util.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@injectable
class InitializeAttributionUseCase {
  InitializeAttributionUseCase(
    this._analyticsRepository,
    this._featuresFlagsRepository,
    this._purchasesRepository,
  );

  final AnalyticsRepository _analyticsRepository;
  final FeaturesFlagsRepository _featuresFlagsRepository;
  final PurchasesRepository _purchasesRepository;

  Future<void> call() async => _initialize().ignore();

  Future<void> _initialize() async {
    try {
      final attribution = await _analyticsRepository.initializeAttribution();
      if (attribution != null) {
        await _featuresFlagsRepository.setupAttribution(attribution);
      }
    } catch (e, s) {
      Fimber.e('Attribution initialization failed', ex: e, stacktrace: s);
    } finally {
      if (defaultTargetPlatform.isApple) {
        await _purchasesRepository.collectAppleSearchAdsAttributionData();
      }

      final appsflyerId = await _analyticsRepository.getAppsflyerId();
      final fbAnonymousId = await _analyticsRepository.getFbAnonymousId();

      await _purchasesRepository.linkWithExternalServices(appsflyerId, fbAnonymousId);
    }
  }
}
