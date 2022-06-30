import 'package:better_informed_mobile/domain/feature_flags/feature_flags_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetShowArticleRelatedContentSectionUseCase {
  GetShowArticleRelatedContentSectionUseCase(this._repository);

  final FeaturesFlagsRepository _repository;

  Future<bool> call() => _repository.showArticleRelatedContentSection();
}
