import 'dart:async';

import 'package:better_informed_mobile/domain/analytics/analytics_page.dt.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/track_activity_use_case.di.dart';
import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:better_informed_mobile/domain/article/exception/article_geoblocked_exception.dart';
import 'package:better_informed_mobile/domain/article/use_case/get_article_header_use_case.di.dart';
import 'package:better_informed_mobile/domain/article/use_case/get_article_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/exception/no_internet_connection_exception.dart';
import 'package:better_informed_mobile/domain/feature_flags/use_case/should_use_paid_subscriptions_use_case.di.dart';
import 'package:better_informed_mobile/domain/networking/use_case/is_internet_connection_available_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/data/active_subscription.dt.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_active_subscription_use_case.di.dart';
import 'package:better_informed_mobile/domain/topic/use_case/trade_topid_id_for_slug_use_case.di.dart';
import 'package:better_informed_mobile/presentation/page/media/media_item_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';

const _maxRefreshTries = 5;

@injectable
class MediaItemCubit extends Cubit<MediaItemState> {
  MediaItemCubit(
    this._getArticleUseCase,
    this._trackActivityUseCase,
    this._getArticleHeaderUseCase,
    this._tradeTopicIdForSlugUseCase,
    this._getActiveSubscriptionUseCase,
    this._shouldUsePaidSubscriptionsUseCase,
    this._isInternetConnectionAvailableUseCase,
  ) : super(const MediaItemState.initializing());

  final GetArticleUseCase _getArticleUseCase;
  final TrackActivityUseCase _trackActivityUseCase;
  final GetArticleHeaderUseCase _getArticleHeaderUseCase;
  final TradeTopicIdForSlugUseCase _tradeTopicIdForSlugUseCase;
  final GetActiveSubscriptionUseCase _getActiveSubscriptionUseCase;
  final ShouldUsePaidSubscriptionsUseCase _shouldUsePaidSubscriptionsUseCase;
  final IsInternetConnectionAvailableUseCase _isInternetConnectionAvailableUseCase;

  late MediaItemArticle _currentArticle;
  late String? _topicSlug;
  late String? _topicId;
  late String? _briefId;

  StreamSubscription? _activeSubscriptionSub;

  String? get topicId => _topicId;
  String? get briefId => _briefId;

  @override
  Future<void> close() async {
    await _activeSubscriptionSub?.cancel();
    await super.close();
  }

  Future<void> initialize(
    MediaItemArticle? article,
    String? slug,
    String? topicId,
    String? topicSlug,
    String? briefId,
  ) async {
    if (article == null && slug == null) {
      emit(MediaItemState.emptyError(article: article));
      Fimber.e('Article and slug were null on article page.');
      return;
    }

    _topicSlug = topicSlug;

    _topicId = topicId;
    _briefId = briefId;

    await _initializeArticle(article, slug);
  }

  Future<void> _initializeArticle(MediaItemArticle? article, String? slug) async {
    if (article != null) {
      await _initializeWithMetadata(article, topicId);
    } else if (slug != null) {
      await _initializeWithSlug(slug, _topicSlug);
    }

    await _setupSubscriptionListener();
  }

  Future<void> _initializeWithMetadata(MediaItemArticle article, String? topicId) async {
    _currentArticle = article;
    emit(MediaItemState.loading(article.category.color));

    _trackActivityUseCase.trackPage(AnalyticsPage.article(article.id, topicId));

    if (article.type == ArticleType.free) {
      await _loadFreeArticle(article);
      return;
    }

    await _loadPremiumArticle(article);
  }

  Future<void> _initializeWithSlug(String slug, String? topicSlug) async {
    emit(const MediaItemState.loading());

    try {
      final article = await _getArticleHeaderUseCase(slug);
      _currentArticle = article;

      await _trackWithTopicSlug(article.id, topicSlug);

      if (article.type == ArticleType.free) {
        await _loadFreeArticle(article);
        return;
      }

      await _loadPremiumArticle(article);
    } on NoInternetConnectionException {
      emit(MediaItemState.offline(article: _currentArticle));
    } catch (e, s) {
      Fimber.e('Fetching article header failed', ex: e, stacktrace: s);
      emit(const MediaItemState.emptyError());
    }
  }

  Future<void> _trackWithTopicSlug(String articleId, String? topicSlug) async {
    if (topicSlug != null) {
      final topicId = await _tradeTopicIdForSlugUseCase(topicSlug);
      _trackActivityUseCase.trackPage(AnalyticsPage.article(articleId, topicId));
    } else {
      _trackActivityUseCase.trackPage(AnalyticsPage.article(articleId));
    }
  }

  Future<void> _loadFreeArticle(MediaItemArticle article) async {
    if (await _isInternetConnectionAvailableUseCase()) {
      emit(MediaItemState.idleFree(article));
    } else {
      emit(MediaItemState.offline(article: article));
    }
  }

  Future<void> _loadPremiumArticle(MediaItemArticle article) async {
    try {
      final fullArticle = await _getArticleUseCase(article);
      _currentArticle = fullArticle.metadata;
      emit(MediaItemState.idlePremium(fullArticle));
    } on ArticleGeoblockedException {
      emit(const MediaItemState.geoblocked());
    } on NoInternetConnectionException {
      emit(MediaItemState.offline(article: article));
    } catch (e, s) {
      Fimber.e('Fetching full article failed', ex: e, stacktrace: s);
      emit(MediaItemState.error(article));
    }
  }

  Future<void> _setupSubscriptionListener() async {
    final shouldUsePaidSubscription = await _shouldUsePaidSubscriptionsUseCase();

    if (!shouldUsePaidSubscription) return;
    if (_activeSubscriptionSub != null) return;

    _activeSubscriptionSub = _getActiveSubscriptionUseCase.stream.distinct().listen((subscription) async {
      if (_doesSubscriptionMatchArticleState(_currentArticle, subscription)) return;

      emit(const MediaItemState.loading());
      await _refreshForSubscriptionState(_currentArticle, subscription);
    });
  }

  Future<void> _refreshForSubscriptionState(MediaItemArticle article, ActiveSubscription subscription) async {
    int counter = 0;
    bool shouldRefresh = true;

    while (shouldRefresh && counter < _maxRefreshTries) {
      try {
        final fullArticle = await _getArticleUseCase(article, refreshMetadata: true);
        _currentArticle = fullArticle.metadata;

        if (_doesSubscriptionMatchArticleState(fullArticle.metadata, subscription)) {
          shouldRefresh = false;
          emit(MediaItemState.idlePremium(fullArticle));
        } else {
          counter++;
          await Future.delayed(const Duration(seconds: 2));
        }
      } on ArticleGeoblockedException {
        shouldRefresh = false;
        emit(const MediaItemState.geoblocked());
      } on NoInternetConnectionException {
        emit(MediaItemState.offline(article: article));
      } catch (e, s) {
        shouldRefresh = false;
        Fimber.e('Fetching full article failed', ex: e, stacktrace: s);
        emit(MediaItemState.error(article));
      }
    }
  }

  bool _doesSubscriptionMatchArticleState(MediaItemArticle article, ActiveSubscription subscription) {
    final expectedAvailability = subscription.maybeMap(
      free: (_) => false,
      orElse: () => true,
    );

    return expectedAvailability == article.availableInSubscription;
  }
}
