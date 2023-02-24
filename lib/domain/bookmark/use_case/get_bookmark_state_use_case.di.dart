import 'package:better_informed_mobile/domain/bookmark/bookmark_local_repository.dart';
import 'package:better_informed_mobile/domain/bookmark/bookmark_remote_repository.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_state.dt.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_type_data.dt.dart';
import 'package:better_informed_mobile/domain/networking/connectivity_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetBookmarkStateUseCase {
  GetBookmarkStateUseCase(
    this._bookmarkRepository,
    this._bookmarkLocalRepository,
    this._connectivityRepository,
  );

  final ConnectivityRepository _connectivityRepository;
  final BookmarkLocalRepository _bookmarkLocalRepository;
  final BookmarkRepository _bookmarkRepository;

  Future<BookmarkState> call(BookmarkTypeData data) async {
    if (await _connectivityRepository.hasInternetConnection()) {
      return data.map(
        article: (data) => _bookmarkRepository.getArticleBookmarkState(data.slug),
        topic: (data) => _bookmarkRepository.getTopicBookmarkState(data.slug),
      );
    }
    return _bookmarkLocalRepository.getBookmarkState(data.slug);
  }
}
