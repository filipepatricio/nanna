import 'package:better_informed_mobile/domain/analytics/attribution_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class InitializeAttributionUseCase {
  InitializeAttributionUseCase(this._attributionRepository);

  final AttributionRepository _attributionRepository;

  Future<void> call() => _attributionRepository.initialize();
}
