import 'package:better_informed_mobile/domain/bookmark/bookmark_change_notifier.di.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_type_data.dt.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetBookmarkChangeStreamUseCase {
  GetBookmarkChangeStreamUseCase(this._notifier);

  final BookmarkChangeNotifier _notifier;

  Stream<BookmarkTypeData> call() {
    return _notifier.stream;
  }
}
