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
  ) : super(BookmarkButtonState.initializing());

  final GetBookmarkStateUseCase _getBookmarkStateUseCase;
  final SwitchBookmarkStateUseCase _setBookmarkStateUseCase;

  Future<void> initialize(BookmarkTypeData data) async {
    emit(BookmarkButtonState.initializing());

    final bookmarkState = await _getBookmarkStateUseCase(data);

    emit(BookmarkButtonState.idle(data, bookmarkState));
  }

  Future<void> switchState() async {
    await state.mapOrNull(
      idle: (state) async {
        emit(BookmarkButtonState.switching(state.data));

        final bookmarkState = await _setBookmarkStateUseCase(
          state.data,
          state.state,
        );

        bookmarkState.map(
          bookmarked: (_) => emit(BookmarkButtonState.bookmarkedSuccess()),
          notBookmarked: (_) => emit(BookmarkButtonState.unbookmarkedSuccess()),
        );

        emit(BookmarkButtonState.idle(state.data, bookmarkState));
      },
    );
  }
}
