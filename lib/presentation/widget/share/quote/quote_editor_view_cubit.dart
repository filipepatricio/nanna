import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/presentation/widget/share/quote/quote_editor_view_state.dart';
import 'package:better_informed_mobile/presentation/widget/share/quote/quote_view.dart';
import 'package:better_informed_mobile/presentation/widget/share/share_util.dart';
import 'package:better_informed_mobile/presentation/widget/share/share_view_image_generator.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class QuoteEditorViewCubit extends Cubit<QuoteEditorViewState> {
  QuoteEditorViewCubit() : super(QuoteEditorViewState.initial());

  void select(int index) {
    final updatedState = state.copyWith(selectedIndex: index);
    emit(updatedState);
  }

  Future<void> share(MediaItemArticle article, String quote) async {
    var fixedQuote = quote;

    if (quote.length > 140) {
      fixedQuote = quote.substring(0, 140) + '...';
    }

    final generator = ShareViewImageGenerator(
      () => QuoteView(
        quote: fixedQuote,
        article: article,
        quoteVariantData: state.variants[state.selectedIndex],
      ),
    );
    await shareImage(generator, 'quote_${DateTime.now().millisecondsSinceEpoch}.png', '');
  }
}
