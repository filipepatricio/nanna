import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/presentation/widget/share/quote/quote_editor_view_state.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class QuoteEditorViewCubit extends Cubit<QuoteEditorViewState> {
  QuoteEditorViewCubit() : super(QuoteEditorViewState.initial());

  void select(int index) {
    final updatedState = state.copyWith(selectedIndex: index);
    emit(updatedState);
  }

  Future<void> shareImage(MediaItemArticle article, String quote) async {}
}
