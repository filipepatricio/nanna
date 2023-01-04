import 'dart:async';

import 'package:better_informed_mobile/domain/analytics/analytics_page.dt.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/track_activity_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/general/get_should_update_article_progress_state_use_case.di.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/domain/topic/use_case/get_topic_by_slug_use_case.di.dart';
import 'package:better_informed_mobile/domain/topic/use_case/mark_topic_as_visited_use_case.di.dart';
import 'package:better_informed_mobile/domain/tutorial/tutorial_steps.dart';
import 'package:better_informed_mobile/domain/tutorial/use_case/is_tutorial_step_seen_use_case.di.dart';
import 'package:better_informed_mobile/domain/tutorial/use_case/set_tutorial_step_seen_use_case.di.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_page_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

@injectable
class TopicPageCubit extends Cubit<TopicPageState> {
  TopicPageCubit(
    this._isTutorialStepSeenUseCase,
    this._setTutorialStepSeenUseCase,
    this._getTopicBySlugUseCase,
    this._trackActivityUseCase,
    this._markTopicAsVisitedUseCase,
    this._getShouldUpdateArticleProgressStateUseCase,
  ) : super(TopicPageState.loading());

  final IsTutorialStepSeenUseCase _isTutorialStepSeenUseCase;
  final SetTutorialStepSeenUseCase _setTutorialStepSeenUseCase;
  final GetTopicBySlugUseCase _getTopicBySlugUseCase;
  final TrackActivityUseCase _trackActivityUseCase;
  final MarkTopicAsVisitedUseCase _markTopicAsVisitedUseCase;
  final GetShouldUpdateArticleProgressStateUseCase _getShouldUpdateArticleProgressStateUseCase;

  late Topic _topic;
  late String? _briefId;

  String? get briefId => _briefId;

  List<TargetFocus> targets = <TargetFocus>[];
  final mediaItemKey = GlobalKey();

  StreamSubscription? _shouldUpdateArticleProgressStateSubscription;

  @override
  Future<void> close() async {
    await _shouldUpdateArticleProgressStateSubscription?.cancel();
    await super.close();
  }

  Future<void> initializeWithSlug(String slug, String? briefId) async {
    emit(TopicPageState.loading());

    try {
      final topic = await _getTopicBySlugUseCase(slug, true);
      initialize(topic, briefId);
    } catch (e, s) {
      Fimber.e('Topic loading failed', ex: e, stacktrace: s);
      emit(TopicPageState.error());
    }
  }

  void initialize(Topic topic, String? briefId) {
    _topic = topic;
    _briefId = briefId;
    if (!topic.visited) {
      try {
        _markTopicAsVisitedUseCase(topic.slug);
      } catch (e, s) {
        Fimber.e('Marking topic as visited failed', ex: e, stacktrace: s);
      }
    }

    _trackActivityUseCase.trackPage(AnalyticsPage.topic(_topic.id, _briefId));

    _shouldUpdateArticleProgressStateSubscription =
        _getShouldUpdateArticleProgressStateUseCase().listen((updatedArticle) {
      state.maybeMap(
        idle: (state) {
          final updatedTopic = updateTopic(state.topic, updatedArticle);
          emit(state.copyWith(topic: updatedTopic));
        },
        orElse: () {},
      );
    });

    emit(TopicPageState.idle(_topic));
  }

  Topic updateTopic(Topic topic, MediaItemArticle updatedArticle) {
    final updatedEntries = topic.entries.map(
      (entry) {
        final updatedItem = entry.item.map(
          article: (article) {
            return article.id == updatedArticle.id ? updatedArticle : article;
          },
          unknown: (unknown) => unknown,
        );
        return entry.copyWith(item: updatedItem);
      },
    ).toList();
    return topic.copyWith(entries: updatedEntries);
  }

  Future<void> initializeTutorialStep() async {
    final isTopicTutorialStepSeen = await _isTutorialStepSeenUseCase(TutorialStep.topic);
    if (!isTopicTutorialStepSeen) {
      emit(TopicPageState.showTutorialToast(LocaleKeys.tutorial_topicSnackBarText.tr()));
      await _setTutorialStepSeenUseCase.call(TutorialStep.topic);
    }
  }
}
