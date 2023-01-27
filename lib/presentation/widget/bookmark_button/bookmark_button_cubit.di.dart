import 'dart:async';

import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/track_activity_use_case.di.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_event.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_state.dt.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_type_data.dt.dart';
import 'package:better_informed_mobile/domain/bookmark/use_case/get_bookmark_change_stream_use_case.di.dart';
import 'package:better_informed_mobile/domain/bookmark/use_case/get_bookmark_state_use_case.di.dart';
import 'package:better_informed_mobile/domain/bookmark/use_case/switch_bookmark_state_use_case.di.dart';
import 'package:better_informed_mobile/domain/networking/use_case/is_internet_connection_available_use_case.di.dart';
import 'package:better_informed_mobile/presentation/util/connection_state_aware_cubit_mixin.dart';
import 'package:better_informed_mobile/presentation/widget/bookmark_button/bookmark_button_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@injectable
class BookmarkButtonCubit extends Cubit<BookmarkButtonState>
    with ConnectionStateAwareCubitMixin<BookmarkButtonState, BookmarkTypeData> {
  BookmarkButtonCubit(
    this._getBookmarkStateUseCase,
    this._setBookmarkStateUseCase,
    this._trackActivityUseCase,
    this._getBookmarkChangeStreamUseCase,
    this._isInternetConnectionAvailableUseCase,
  ) : super(BookmarkButtonState.initializing());

  final GetBookmarkStateUseCase _getBookmarkStateUseCase;
  final SwitchBookmarkStateUseCase _setBookmarkStateUseCase;
  final TrackActivityUseCase _trackActivityUseCase;
  final GetBookmarkChangeStreamUseCase _getBookmarkChangeStreamUseCase;
  final IsInternetConnectionAvailableUseCase _isInternetConnectionAvailableUseCase;

  StreamSubscription? _notifierSubscription;

  @override
  IsInternetConnectionAvailableUseCase get isInternetConnectionAvailableUseCase =>
      _isInternetConnectionAvailableUseCase;

  @override
  Future<void> onOffline(BookmarkTypeData initialData) async {
    state.maybeMap(
      idle: (state) => emit(BookmarkButtonState.offline(state.state)),
      orElse: () => emit(BookmarkButtonState.offline(BookmarkState.notBookmarked())),
    );
    await _notifierSubscription?.cancel();
  }

  @override
  Future<void> onOnline(BookmarkTypeData initialData) async {
    emit(BookmarkButtonState.initializing());

    final bookmarkState = await _getBookmarkStateUseCase(initialData);

    if (!isClosed) {
      emit(BookmarkButtonState.idle(initialData, bookmarkState));
    }

    _registerBookmarkChangeNotification(initialData);
  }

  @override
  Future<void> close() {
    _notifierSubscription?.cancel();
    return super.close();
  }

  Future<void> initialize(BookmarkTypeData data) async {
    await initializeConnection(data);
  }

  void _registerBookmarkChangeNotification(BookmarkTypeData data) {
    _notifierSubscription = _getBookmarkChangeStreamUseCase(includeProfileEvents: true)
        .debounceTime(const Duration(milliseconds: 100))
        .switchMap((event) => _reloadOnChangeNotification(event, data))
        .listen(_handleBookmarkState);
  }

  Stream<BookmarkState> _reloadOnChangeNotification(BookmarkEvent event, BookmarkTypeData data) async* {
    if (event.data.slug != data.slug) {
      return;
    }
    yield event.state;
  }

  void _handleBookmarkState(BookmarkState bookmarkState) {
    if (isClosed) return;

    state.mapOrNull(
      idle: (state) => emit(BookmarkButtonState.idle(state.data, bookmarkState)),
    );
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
