import 'package:better_informed_mobile/domain/analytics/analytics_event.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/track_activity_use_case.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_type_data.dart';
import 'package:better_informed_mobile/domain/bookmark/use_case/get_bookmark_state_use_case.dart';
import 'package:better_informed_mobile/domain/bookmark/use_case/switch_bookmark_state_use_case.dart';
import 'package:better_informed_mobile/presentation/widget/bookmark_button/bookmark_button_state.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class BookmarkButtonCubit extends Cubit<BookmarkButtonState> {
  BookmarkButtonCubit(
    this._getBookmarkStateUseCase,
    this._setBookmarkStateUseCase,
    this._trackActivityUseCase,
  ) : super(BookmarkButtonState.initializing());

  final GetBookmarkStateUseCase _getBookmarkStateUseCase;
  final SwitchBookmarkStateUseCase _setBookmarkStateUseCase;
  final TrackActivityUseCase _trackActivityUseCase;

  Future<void> initialize(BookmarkTypeData data) async {
    emit(BookmarkButtonState.initializing());

    final bookmarkState = await _getBookmarkStateUseCase(data);

    emit(BookmarkButtonState.idle(data, bookmarkState));
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
