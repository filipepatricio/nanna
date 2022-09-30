import 'package:better_informed_mobile/domain/article/article_repository.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry_item.dt.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetOtherBriefEntriesUseCase {
  GetOtherBriefEntriesUseCase(this._articleRepository);

  final ArticleRepository _articleRepository;

  Future<List<BriefEntryItem>> call(
    String slug,
    String briefId,
  ) {
    return _articleRepository.getOtherBriefEntries(
      slug,
      briefId,
    );
  }
}
