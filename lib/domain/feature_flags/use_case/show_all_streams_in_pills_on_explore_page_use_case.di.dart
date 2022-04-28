import 'package:better_informed_mobile/domain/feature_flags/feature_flags_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ShowAllStreamsInPillsOnExplorePageUseCase {
  final FeaturesFlagsRepository _featuresFlagsRepository;

  ShowAllStreamsInPillsOnExplorePageUseCase(
    this._featuresFlagsRepository,
  );

  Future<bool> call() async {
    return await _featuresFlagsRepository.showAllStreamsInPillsOnExplorePage();
  }
}
