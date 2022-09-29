import 'package:better_informed_mobile/domain/analytics/analytics_repository.dart';
import 'package:better_informed_mobile/domain/feature_flags/feature_flags_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class InitializeAttributionUseCase {
  InitializeAttributionUseCase(
    this._analyticsRepository,
    this._featuresFlagsRepository,
  );

  final AnalyticsRepository _analyticsRepository;
  final FeaturesFlagsRepository _featuresFlagsRepository;

  Future<void> call() async {
    final attribution = await _analyticsRepository.initializeAttribution();
    if (attribution != null) {
      await _featuresFlagsRepository.setupAttribution(attribution);
    }
  }
}
