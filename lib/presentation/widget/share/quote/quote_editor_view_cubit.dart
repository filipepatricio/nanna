import 'package:better_informed_mobile/domain/analytics/analytics_event.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/track_activity_use_case.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/generated/local_keys.g.dart';
import 'package:better_informed_mobile/presentation/widget/share/quote/quote_background_view.dart';
import 'package:better_informed_mobile/presentation/widget/share/quote/quote_editor_view_state.dart';
import 'package:better_informed_mobile/presentation/widget/share/quote/quote_foreground_view.dart';
import 'package:better_informed_mobile/presentation/widget/share/share_util.dart';
import 'package:better_informed_mobile/presentation/widget/share/share_view_image_generator.dart';
import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:injectable/injectable.dart';
import 'package:share_plus/share_plus.dart';
import 'package:social_share/social_share.dart';

@injectable
class QuoteEditorViewCubit extends Cubit<QuoteEditorViewState> {
  QuoteEditorViewCubit(
    this._trackActivityUseCase,
  ) : super(QuoteEditorViewState.initial());

  final TrackActivityUseCase _trackActivityUseCase;

  Future<void> initialize() async {
    final isInstagramAvailable = await _isInstagramAvailable();
    emit(
      QuoteEditorViewState(
        state.variants,
        state.selectedIndex,
        isInstagramAvailable,
      ),
    );
  }

  void select(int index) {
    final updatedState = state.copyWith(selectedIndex: index);
    emit(updatedState);
  }

  Future<void> shareSticker(MediaItemArticle article, String quote) async {
    final fixedQuote = _getFixedQuote(quote);
    final shareText = tr(
      LocaleKeys.shareQuote_message,
      args: [
        article.url,
      ],
    );

    final generator = ShareViewImageGenerator(
      () => QuoteForegroundView(
        quote: fixedQuote,
        article: article,
        quoteVariantData: state.variants[state.selectedIndex],
      ),
    );

    await shareImage(
      generator,
      'quote_${DateTime.now().millisecondsSinceEpoch}.png',
      shareText,
    );

    _trackActivityUseCase.trackEvent(
      AnalyticsEvent.imageArticleQuoteShared(
        article.id,
        fixedQuote,
      ),
    );
  }

  Future<void> shareText(MediaItemArticle article, String quote) async {
    final fixedQuote = _getFixedQuote(quote);

    await Share.share(
      tr(
        LocaleKeys.shareQuote_messageWithQuote,
        args: [
          '‘‘$fixedQuote’’',
          article.url,
        ],
      ),
    );

    _trackActivityUseCase.trackEvent(
      AnalyticsEvent.textArticleQuoteShared(
        article.id,
        fixedQuote,
      ),
    );
  }

  Future<void> shareStory(MediaItemArticle article, String quote) async {
    final fixedQuote = _getFixedQuote(quote);

    final backgroundGenerator = ShareViewImageGenerator(
      () => QuoteBackgroundView(
        article: article,
      ),
    );
    final backgroundImage = await generateShareImage(
      backgroundGenerator,
      'quote_${DateTime.now().millisecondsSinceEpoch}_background.png',
    );

    final foregroundGenerator = ShareViewImageGenerator(
      () => QuoteForegroundView(
        quote: fixedQuote,
        article: article,
        quoteVariantData: state.variants[state.selectedIndex],
      ),
    );
    final foregroundImage = await generateShareImage(
      foregroundGenerator,
      'quote_${DateTime.now().millisecondsSinceEpoch}_foreground.png',
    );

    await SocialShare.shareInstagramStory(
      foregroundImage.path,
      backgroundImagePath: backgroundImage.path,
      attributionURL: article.url,
      backgroundBottomColor: '',
      backgroundTopColor: '',
    );
  }

  String _getFixedQuote(String quote) {
    var fixedQuote = quote;

    if (quote.length > 140) {
      fixedQuote = quote.substring(0, 140) + '...';
    }

    return fixedQuote;
  }

  Future<bool> _isInstagramAvailable() async {
    final apps = await SocialShare.checkInstalledAppsForShare();
    return apps != null && apps['instagram'] == true;
  }
}
