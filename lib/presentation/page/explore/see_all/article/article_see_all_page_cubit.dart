import 'package:better_informed_mobile/domain/analytics/analytics_event.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/track_activity_use_case.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/domain/explore/use_case/get_explore_paginated_articles_use_case.dart';
import 'package:better_informed_mobile/presentation/page/explore/see_all/article/article_see_all_page_state.dart';
import 'package:better_informed_mobile/presentation/page/explore/see_all/article/article_with_background.dart';
import 'package:better_informed_mobile/presentation/page/explore/see_all/article/next_article_page_loader.dart';
import 'package:better_informed_mobile/presentation/util/pagination/pagination_engine.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

const _paginationLimit = 10;

@injectable
class ArticleSeeAllPageCubit extends Cubit<ArticleSeeAllPageState> {
  final GetExplorePaginatedArticlesUseCase _getExplorePaginatedArticlesUseCase;
  final TrackActivityUseCase _trackActivityUseCase;
  late NextArticlePageLoader _nextArticlePageLoader;
  late PaginationEngine<MediaItemArticle> _paginationEngine;
  late String _areaId;

  List<ArticleWithBackground> _articles = [];
  bool _allLoaded = false;

  ArticleSeeAllPageCubit(
    this._getExplorePaginatedArticlesUseCase,
    this._trackActivityUseCase,
  ) : super(ArticleSeeAllPageState.loading());

  Future<void> initialize(String areaId, List<MediaItemArticle> articles) async {
    _areaId = areaId;
    _articles = _processArticles(articles).toList();
    _nextArticlePageLoader = NextArticlePageLoader(_getExplorePaginatedArticlesUseCase, areaId);
    _paginationEngine = PaginationEngine(_nextArticlePageLoader);
    _paginationEngine.initialize(articles);

    _trackActivityUseCase.trackEvent(AnalyticsEvent.exploreAreaScrolled(_areaId, 0));

    emit(ArticleSeeAllPageState.withPagination(_articles));
  }

  Future<void> loadNextPage() async {
    if (_isInLoadingState() || _allLoaded) return;

    emit(ArticleSeeAllPageState.loadingMore(_articles));

    _trackActivityUseCase.trackEvent(AnalyticsEvent.exploreAreaScrolled(_areaId, _articles.length));

    final limit = _articles.length.isEven ? _paginationLimit : _paginationLimit - 1;
    final result = await _paginationEngine.loadMore(limitOverride: limit);

    _articles = _processArticles(result.data).toList();
    _allLoaded = result.allLoaded;

    if (_allLoaded) {
      emit(ArticleSeeAllPageState.allLoaded(_articles));
    } else {
      emit(ArticleSeeAllPageState.withPagination(_articles));
    }
  }

  bool _isInLoadingState() => state.maybeMap(
        loadingMore: (_) => true,
        orElse: () => false,
      );

  Iterable<ArticleWithBackground> _processArticles(List<MediaItemArticle> articles) sync* {
    var nextColorIndex = 0;

    for (var i = 0; i < articles.length; i++) {
      final article = articles[i];
      final image = article.image;

      if (image == null) {
        yield ArticleWithBackground.color(article, nextColorIndex++);
      } else {
        yield ArticleWithBackground.image(article, image);
      }
    }
  }
}
