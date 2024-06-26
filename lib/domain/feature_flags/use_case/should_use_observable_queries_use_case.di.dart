import 'package:better_informed_mobile/domain/feature_flags/feature_flags_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ShouldUseObservableQueriesUseCase {
  ShouldUseObservableQueriesUseCase(
    this._featuresFlagsRepository,
  );
  final FeaturesFlagsRepository _featuresFlagsRepository;

  Future<bool> call() async => await _featuresFlagsRepository.useObservableQueries();
}
