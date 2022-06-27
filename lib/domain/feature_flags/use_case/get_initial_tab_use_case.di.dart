import 'package:better_informed_mobile/domain/feature_flags/feature_flags_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetInitialTabUseCase {
  GetInitialTabUseCase(
    this._featuresFlagsRepository,
  );
  final FeaturesFlagsRepository _featuresFlagsRepository;

  Future<String> call() async {
    return await _featuresFlagsRepository.initialTab();
  }
}
