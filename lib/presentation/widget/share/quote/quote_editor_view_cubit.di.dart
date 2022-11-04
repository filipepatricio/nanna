import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/track_activity_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/share/data/share_content.dt.dart';
import 'package:better_informed_mobile/domain/share/data/share_options.dart';
import 'package:better_informed_mobile/domain/share/use_case/get_share_options_list_use_case.di.dart';
import 'package:better_informed_mobile/domain/share/use_case/share_content_use_case.di.dart';
import 'package:better_informed_mobile/presentation/widget/share/article/share_article_background_view.dart';
import 'package:better_informed_mobile/presentation/widget/share/quote/quote_editor_view_state.dt.dart';
import 'package:better_informed_mobile/presentation/widget/share/quote/share_quote_view.dart';
import 'package:better_informed_mobile/presentation/widget/share/share_util.dart';
import 'package:better_informed_mobile/presentation/widget/share/share_view_image_generator.di.dart';
import 'package:bloc/bloc.dart';
import 'package:clock/clock.dart';
import 'package:injectable/injectable.dart';

@injectable
class QuoteEditorViewCubit extends Cubit<QuoteEditorViewState> {
  QuoteEditorViewCubit(
    this._trackActivityUseCase,
    this._getShareOptionsListUseCase,
    this._shareViewImageGenerator,
    this._shareContentUseCase,
  ) : super(QuoteEditorViewState(false));

  final TrackActivityUseCase _trackActivityUseCase;
  final GetShareOptionsListUseCase _getShareOptionsListUseCase;
  final ShareViewImageGenerator _shareViewImageGenerator;
  final ShareContentUseCase _shareContentUseCase;

  Future<void> initialize() async {
    final isInstagramAvailable = await _isInstagramAvailable();
    emit(
      QuoteEditorViewState(
        isInstagramAvailable,
      ),
    );
  }

  Future<void> shareSticker(MediaItemArticle article, String quote) async {
    final fixedQuote = _getFixedQuote(quote);
    final shareText = article.url;

    ShareQuoteStickerView factory() => ShareQuoteStickerView(
          quote: fixedQuote,
          article: article,
        );

    final image = await generateShareImage(
      _shareViewImageGenerator,
      factory,
      'quote_${clock.now().millisecondsSinceEpoch}.png',
    );

    await _shareContentUseCase(
      ShareContent.image(
        ShareOption.more,
        image,
        shareText,
      ),
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

    await _shareContentUseCase(
      ShareContent.text(
        ShareOption.more,
        '“$fixedQuote”\n\n${article.url}',
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

    ShareQuoteStickerView foregroundFactory() {
      return ShareQuoteStickerView(
        quote: fixedQuote,
        article: article,
      );
    }

    ShareArticleBackgroundView backgroundFactory() {
      return ShareArticleBackgroundView(article: article);
    }

    final foregroundImageFuture = generateShareImage(
      _shareViewImageGenerator,
      foregroundFactory,
      'quote_${clock.now().millisecondsSinceEpoch}_foreground.png',
    );

    final backgroundImageFuture = generateShareImage(
      _shareViewImageGenerator,
      backgroundFactory,
      'quote_${clock.now().millisecondsSinceEpoch}_background.png',
    );

    final images = await Future.wait(
      [
        foregroundImageFuture,
        backgroundImageFuture,
      ],
    );

    await _shareContentUseCase(
      ShareContent.instagram(
        images[0],
        images[1],
        article.url,
      ),
    );

    _trackActivityUseCase.trackEvent(
      AnalyticsEvent.storyArticleQuoteShared(
        article.id,
        fixedQuote,
      ),
    );
  }

  String _getFixedQuote(String quote) {
    var fixedQuote = quote;

    if (quote.length > 140) {
      fixedQuote = '${quote.substring(0, 140)}...';
    }

    return fixedQuote;
  }

  Future<bool> _isInstagramAvailable() async {
    final shareOptions = await _getShareOptionsListUseCase();
    return shareOptions.contains(ShareOption.instagram);
  }
}
