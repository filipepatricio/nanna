import 'package:better_informed_mobile/domain/bookmark/bookmark_local_repository.dart';
import 'package:better_informed_mobile/domain/bookmark/bookmark_remote_repository.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_filter.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_order.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_sort.dart';
import 'package:better_informed_mobile/domain/bookmark/use_case/save_bookmarked_media_item_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/has_active_subscription_use_case.di.dart';
import 'package:clock/clock.dart';
import 'package:injectable/injectable.dart';

const _bookmarksBatchSize = 25;

@injectable
class RunIntitialBookmarkSyncUseCase {
  RunIntitialBookmarkSyncUseCase(
    this._bookmarkRepository,
    this._bookmarkLocalRepository,
    this._saveBookmarkedMediaItemUseCase,
    this._hasActiveSubscriptionUseCase,
  );

  final BookmarkRepository _bookmarkRepository;
  final BookmarkLocalRepository _bookmarkLocalRepository;
  final SaveBookmarkedMediaItemUseCase _saveBookmarkedMediaItemUseCase;
  final HasActiveSubscriptionUseCase _hasActiveSubscriptionUseCase;

  Future<void> call({bool force = false}) async {
    if (!await _hasActiveSubscriptionUseCase()) return;

    final lastSyncedAt = await _bookmarkLocalRepository.loadLastSynchronizationTime();
    if (!force && lastSyncedAt != null) return;

    final localBookmarks = await _bookmarkLocalRepository.getAllIds();

    var offset = 0;
    var hasMore = true;

    while (hasMore) {
      final bookmarksBatch = await _bookmarkRepository.getPaginatedBookmarks(
        limit: _bookmarksBatchSize,
        offset: offset,
        filter: BookmarkFilter.all,
        order: BookmarkOrder.ascending,
        sort: BookmarkSort.added,
      );

      offset += bookmarksBatch.length;

      if (bookmarksBatch.length != _bookmarksBatchSize) {
        hasMore = false;
      }

      for (final bookmark in bookmarksBatch) {
        if (!localBookmarks.contains(bookmark.id)) {
          await _saveBookmarkedMediaItemUseCase.usingBookmarkData(bookmark.data, bookmark.id);
        }
      }
    }

    await _bookmarkLocalRepository.saveSynchronizationTime(clock.now());
  }
}
