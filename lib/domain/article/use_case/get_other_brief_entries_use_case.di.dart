import 'package:better_informed_mobile/domain/article/article_repository.dart';
import 'package:better_informed_mobile/domain/article/data/other_brief_entry_item.dt.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetOtherBriefEntriesUseCase {
  GetOtherBriefEntriesUseCase(this._articleRepository);

  final ArticleRepository _articleRepository;

  Future<List<OtherBriefEntryItem>> call(String slug) => _articleRepository.getOtherBriefEntries(slug);
}
