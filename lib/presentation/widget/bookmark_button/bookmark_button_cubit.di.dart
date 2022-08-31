import 'dart:async';

import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/track_activity_use_case.di.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_state.dt.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_type_data.dt.dart';
import 'package:better_informed_mobile/domain/bookmark/use_case/get_bookmark_change_stream_use_case.di.dart';
import 'package:better_informed_mobile/domain/bookmark/use_case/get_bookmark_state_use_case.di.dart';
import 'package:better_informed_mobile/domain/bookmark/use_case/switch_bookmark_state_use_case.di.dart';
import 'package:better_informed_mobile/presentation/widget/bookmark_button/bookmark_button_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@injectable
class BookmarkButtonCubit extends Cubit<BookmarkButtonState> {
  BookmarkButtonCubit(
    this._getBookmarkStateUseCase,
    this._setBookmarkStateUseCase,
    this._trackActivityUseCase,
    this._getBookmarkChangeStreamUseCase,
  ) : super(BookmarkButtonState.initializing());

  final GetBookmarkStateUseCase _getBookmarkStateUseCase;
  final SwitchBookmarkStateUseCase _setBookmarkStateUseCase;
  final TrackActivityUseCase _trackActivityUseCase;
  final GetBookmarkChangeStreamUseCase _getBookmarkChangeStreamUseCase;

  StreamSubscription? _notifierSubscription;

  late BookmarkTypeData bookmarkTypeData;

  @override
  Future<void> close() {
    _notifierSubscription?.cancel();
    return super.close();
  }

  Future<void> initialize(BookmarkTypeData data) async {
    emit(BookmarkButtonState.initializing());

    bookmarkTypeData = data;

    final bookmarkState = await _getBookmarkStateUseCase(data);

    if (!isClosed) {
      emit(BookmarkButtonState.idle(data, bookmarkState));
    }

    _registerBookmarkChangeNotification(data);
  }

  void _registerBookmarkChangeNotification(BookmarkTypeData data) {
    _notifierSubscription = _getBookmarkChangeStreamUseCase()
        .debounceTime(const Duration(seconds: 1))
        .switchMap((changedData) => _reloadOnChangeNotification(data, changedData))
        .listen(_handleBookmarkState);
  }

  Stream<BookmarkState> _reloadOnChangeNotification(BookmarkTypeData data, BookmarkTypeData changedData) async* {
    if (data.slug != changedData.slug) {
      return;
    }
    emit(BookmarkButtonState.switching(data));
    yield await _getBookmarkStateUseCase(data);
  }

  void _handleBookmarkState(BookmarkState bookmarkState) {
    if (isClosed) return;

    emit(BookmarkButtonState.idle(bookmarkTypeData, bookmarkState));
  }

  Future<void> switchState({bool? fromUndo}) async {
    await state.mapOrNull(
      idle: (state) async {
        emit(BookmarkButtonState.switching(state.data));

        final bookmarkState = await _setBookmarkStateUseCase(
          state.data,
          state.state,
        );

        bookmarkState.mapOrNull(
          bookmarked: (_) {
            if (fromUndo == true) {
              _trackBookmarkRemoveUndo(state.data);
            } else {
              emit(BookmarkButtonState.bookmarkAdded());
            }
          },
          notBookmarked: (_) => emit(BookmarkButtonState.bookmarkRemoved()),
        );

        emit(BookmarkButtonState.idle(state.data, bookmarkState));
      },
    );
  }

  void _trackBookmarkRemoveUndo(BookmarkTypeData data) {
    data.map(
      article: (article) => _trackActivityUseCase.trackEvent(
        AnalyticsEvent.articleBookmarkRemoveUndo(
          article.articleId,
          article.topicId,
          article.briefId,
        ),
      ),
      topic: (topic) => _trackActivityUseCase.trackEvent(
        AnalyticsEvent.topicBookmarkRemoveUndo(
          topic.topicId,
          topic.briefId,
        ),
      ),
    );
  }
}
