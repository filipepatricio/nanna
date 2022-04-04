import 'package:better_informed_mobile/domain/analytics/analytics_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class InitializeAnalyticsUseCase {
  final AnalyticsRepository _analyticsRepository;

  InitializeAnalyticsUseCase(this._analyticsRepository);

  Future<void> call() => _analyticsRepository.initialize();
}
