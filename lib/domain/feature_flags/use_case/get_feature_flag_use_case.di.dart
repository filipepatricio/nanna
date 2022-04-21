import 'package:better_informed_mobile/domain/feature_flags/feature_flags_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetFeatureFlagUseCase {
  final FeaturesFlagsRepository _featuresFlagsRepository;

  GetFeatureFlagUseCase(
    this._featuresFlagsRepository,
  );

  Future<T> call<T>(String flagKey, T defaultValue) async {
    return await _featuresFlagsRepository.getFlag<T>(flagKey, defaultValue);
  }
}
