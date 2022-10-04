import 'package:better_informed_mobile/domain/analytics/analytics_repository.dart';
import 'package:better_informed_mobile/domain/feature_flags/feature_flags_repository.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';

@injectable
class InitializeAttributionUseCase {
  InitializeAttributionUseCase(
    this._analyticsRepository,
    this._featuresFlagsRepository,
  );

  final AnalyticsRepository _analyticsRepository;
  final FeaturesFlagsRepository _featuresFlagsRepository;

  Future<void> call() async => _initialize().ignore();

  Future<void> _initialize() async {
    try {
      final attribution = await _analyticsRepository.initializeAttribution();
      if (attribution != null) {
        await _featuresFlagsRepository.setupAttribution(attribution);
      }
    } catch (e, s) {
      Fimber.e('Attribution initialization failed', ex: e, stacktrace: s);
    }
  }
}
