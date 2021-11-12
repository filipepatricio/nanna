import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/domain/explore/use_case/get_explore_paginated_articles_use_case.dart';
import 'package:better_informed_mobile/presentation/page/explore_tab/see_all/article/article_see_all_page_state.dart';
import 'package:better_informed_mobile/presentation/page/explore_tab/see_all/article/next_article_page_loader.dart';
import 'package:better_informed_mobile/presentation/util/pagination/pagination_engine.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

const _paginationLimit = 10;

@injectable
class ArticleSeeAllPageCubit extends Cubit<ArticleSeeAllPageState> {
  final GetExplorePaginatedArticlesUseCase _getExplorePaginatedArticlesUseCase;
  late NextArticlePageLoader _nextArticlePageLoader;
  late PaginationEngine<MediaItemArticle> _paginationEngine;

  List<MediaItemArticle> _articles = [];
  bool _allLoaded = false;

  ArticleSeeAllPageCubit(
    this._getExplorePaginatedArticlesUseCase,
  ) : super(ArticleSeeAllPageState.loading());

  Future<void> initialize(String sectionId, List<MediaItemArticle> articles) async {
    _articles = articles;
    _nextArticlePageLoader = NextArticlePageLoader(_getExplorePaginatedArticlesUseCase, sectionId);
    _paginationEngine = PaginationEngine(_nextArticlePageLoader);
    _paginationEngine.initialize(articles);

    emit(ArticleSeeAllPageState.withPagination(articles));
  }

  Future<void> loadNextPage() async {
    if (_isInLoadingState() || _allLoaded) return;

    emit(ArticleSeeAllPageState.loadingMore(_articles));
    final limit = _articles.length.isEven ? _paginationLimit : _paginationLimit - 1;
    final result = await _paginationEngine.loadMore(limitOverride: limit);

    _articles = result.data;
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
}
