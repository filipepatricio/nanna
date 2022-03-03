import 'package:better_informed_mobile/domain/bookmark/bookmark_repository.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_state.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_type_data.dart';
import 'package:injectable/injectable.dart';

@injectable
class SwitchBookmarkStateUseCase {
  SwitchBookmarkStateUseCase(this._bookmarkRepository);

  final BookmarkRepository _bookmarkRepository;

  Future<BookmarkState> call(
    BookmarkTypeData data,
    BookmarkState state,
  ) async {
    return state.map(
      bookmarked: (state) => _bookmarkRepository.removeBookmark(state.id),
      notBookmarked: (state) => _bookmark(data),
    );
  }

  Future<BookmarkState> _bookmark(BookmarkTypeData data) async {
    return data.map(
      article: (data) => _bookmarkRepository.bookmarkArticle(data.slug),
      topic: (data) => _bookmarkRepository.bookmarkTopic(data.slug),
    );
  }
}
