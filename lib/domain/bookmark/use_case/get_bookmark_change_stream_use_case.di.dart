import 'package:better_informed_mobile/domain/bookmark/bookmark_change_notifier.di.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_event.dart';
import 'package:better_informed_mobile/domain/bookmark/profile_bookmark_change_notifier.di.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@injectable
class GetBookmarkChangeStreamUseCase {
  GetBookmarkChangeStreamUseCase(this._notifier, this._profileNotifier);

  final BookmarkChangeNotifier _notifier;
  final ProfileBookmarkChangeNotifier _profileNotifier;

  Stream<BookmarkEvent> call({bool includeProfileEvents = false}) {
    if (includeProfileEvents) {
      final stream = Rx.merge([
        _notifier.stream,
        _profileNotifier.stream,
      ]);
      return stream;
    }
    return _notifier.stream;
  }
}
