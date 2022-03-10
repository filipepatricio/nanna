import 'package:better_informed_mobile/domain/bookmark/bookmark_change_notifier.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_filter.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetBookmarkChangeStreamUseCase {
  GetBookmarkChangeStreamUseCase(this._notifier);

  final BookmarkChangeNotifier _notifier;

  Stream<List<BookmarkFilter>> call(BookmarkFilter filter) {
    return _notifier.stream.where((filters) => filters.contains(filter));
  }
}
