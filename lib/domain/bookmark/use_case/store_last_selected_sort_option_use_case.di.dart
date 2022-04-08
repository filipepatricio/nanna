import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_repository.dart';
import 'package:better_informed_mobile/domain/bookmark/bookmark_local_repository.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_sort_config.dart';
import 'package:injectable/injectable.dart';

@injectable
class StoreLastSelectedSortOptionUseCase {
  StoreLastSelectedSortOptionUseCase(
    this._bookmarkLocalRepository,
    this._analyticsRepository,
  );

  final BookmarkLocalRepository _bookmarkLocalRepository;
  final AnalyticsRepository _analyticsRepository;

  Future<void> call(BookmarkSortConfigName configName) async {
    await _bookmarkLocalRepository.saveSortOption(configName);
    _analyticsRepository.event(
      AnalyticsEvent.bookmarkSortingOptionSelected(
        configName,
      ),
    );
  }
}
