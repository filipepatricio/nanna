import 'package:better_informed_mobile/domain/article/article_repository.dart';
import 'package:better_informed_mobile/domain/categories/data/category_item.dt.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetRelatedContentUseCase {
  GetRelatedContentUseCase(this._repository);

  final ArticleRepository _repository;

  Future<List<CategoryItem>> call(String slug) => _repository.getRelatedContent(slug);
}
