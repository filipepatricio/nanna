import 'package:better_informed_mobile/domain/bookmark/bookmark_local_repository.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_sort_config.dart';
import 'package:injectable/injectable.dart';

const _defaultSortConfig = BookmarkSortConfigName.lastAdded;

@injectable
class GetBookmarkSortOptionUseCase {
  GetBookmarkSortOptionUseCase(this._bookmarkLocalRepository);

  final BookmarkLocalRepository _bookmarkLocalRepository;

  Future<BookmarkSortConfigName> call() async {
    final storedConfig = await _bookmarkLocalRepository.loadSortOption();

    if (storedConfig == null) return _defaultSortConfig;
    return storedConfig;
  }
}
