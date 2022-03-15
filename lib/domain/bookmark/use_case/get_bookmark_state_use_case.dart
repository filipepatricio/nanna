import 'package:better_informed_mobile/domain/bookmark/bookmark_remote_repository.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_state.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_type_data.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetBookmarkStateUseCase {
  GetBookmarkStateUseCase(this._bookmarkRepository);

  final BookmarkRepository _bookmarkRepository;

  Future<BookmarkState> call(BookmarkTypeData data) async {
    return data.map(
      article: (data) => _bookmarkRepository.getArticleBookmarkState(data.slug),
      topic: (data) => _bookmarkRepository.getTopicBookmarkState(data.slug),
    );
  }
}
