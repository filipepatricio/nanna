import 'package:better_informed_mobile/domain/explore/data/explore_content.dart';
import 'package:better_informed_mobile/domain/explore/explore_content_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetExploreContentUseCase {
  final ExploreContentRepository _exploreContentRepository;

  GetExploreContentUseCase(this._exploreContentRepository);

  Future<ExploreContent> call() async => _exploreContentRepository.getExploreContent();
}
