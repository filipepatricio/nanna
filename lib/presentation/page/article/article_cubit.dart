import 'package:better_informed_mobile/domain/article/data/article_data.dart';
import 'package:better_informed_mobile/domain/article/data/reading_banner.dart';
import 'package:better_informed_mobile/domain/article/use_case/set_reading_banner_use_case.dart';
import 'package:better_informed_mobile/presentation/page/reading_banner/reading_banner_cubit.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

import 'article_state.dart';

@injectable
class ArticleCubit extends Cubit<ArticleState> {
  final SetReadingBannerStreamUseCase _setStartedArticleStreamUseCase;

  ArticleCubit(this._setStartedArticleStreamUseCase) : super(const ArticleState.idle());

  var readingComplete = false;

  void updateReadingBannerState(Article articleData, double progress, double scrollOffset) {
    if (!readingComplete) {
      if (progress == scrollEnd) {
        readingComplete = true;
      }
      final readingBanner = ReadingBanner(article: articleData, scrollProgress: progress, scrollOffset: scrollOffset);
      _setStartedArticleStreamUseCase.call(readingBanner);
    }
  }

  void resetBannerState(Article articleData, double progress, double scrollOffset) {
    readingComplete = false;
    final readingBanner = ReadingBanner(article: articleData, scrollProgress: progress, scrollOffset: scrollOffset);
    _setStartedArticleStreamUseCase.call(readingBanner);
  }
}
