import 'dart:async';

import 'package:better_informed_mobile/domain/analytics/analytics_page.dt.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/track_activity_use_case.di.dart';
import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:better_informed_mobile/domain/article/exception/article_geoblocked_exception.dart';
import 'package:better_informed_mobile/domain/article/use_case/get_article_header_use_case.di.dart';
import 'package:better_informed_mobile/domain/article/use_case/get_article_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/feature_flags/use_case/should_use_paid_subscriptions_use_case.di.dart';
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
  ) : super(const MediaItemState.initializing());

  final GetArticleUseCase _getArticleUseCase;
  final TrackActivityUseCase _trackActivityUseCase;
  final GetArticleHeaderUseCase _getArticleHeaderUseCase;
  final TradeTopicIdForSlugUseCase _tradeTopicIdForSlugUseCase;
  final GetActiveSubscriptionUseCase _getActiveSubscriptionUseCase;
  final ShouldUsePaidSubscriptionsUseCase _shouldUsePaidSubscriptionsUseCase;

  late MediaItemArticle _currentArticle;
  late String? _topicId;
  late String? _briefId;

  StreamSubscription? _activeSubscriptionSub;

  String? get topicId => _topicId;
  String? get briefId => _briefId;

  @override
  Future<void> close() async {
    await Future.wait(
      [
        _activeSubscriptionSub?.cancel(),
        super.close(),
      ].whereType(),
    );
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

    _topicId = topicId;
    _briefId = briefId;

    if (article != null) {
      await _initializeWithArticle(article, topicId);
    } else if (slug != null) {
      await _initializeWithSlug(slug, topicSlug);
    }

    await _setupSubscriptionListener();
  }

  Future<void> _initializeWithArticle(MediaItemArticle article, String? topicId) async {
    _currentArticle = article;
    _trackActivityUseCase.trackPage(AnalyticsPage.article(article.id, topicId));

    emit(MediaItemState.loading(_currentArticle.category.color));

    if (article.type == ArticleType.free) {
      emit(MediaItemState.idleFree(article));
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
        emit(MediaItemState.idleFree(article));
        return;
      }

      await _loadPremiumArticle(article);
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

  Future<void> _loadPremiumArticle(MediaItemArticle article) async {
    try {
      final fullArticle = await _getArticleUseCase(article);
      _currentArticle = fullArticle.metadata;
      emit(MediaItemState.idlePremium(fullArticle));
    } on ArticleGeoblockedException {
      emit(const MediaItemState.geoblocked());
    } catch (e, s) {
      Fimber.e('Fetching full article failed', ex: e, stacktrace: s);
      emit(MediaItemState.error(_currentArticle));
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
      } catch (e, s) {
        shouldRefresh = false;
        Fimber.e('Fetching full article failed', ex: e, stacktrace: s);
        emit(MediaItemState.error(_currentArticle));
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
