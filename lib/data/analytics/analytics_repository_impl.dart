import 'package:better_informed_mobile/domain/analytics/analytics_event.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_page.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_repository.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_segment/flutter_segment.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AnalyticsRepository)
class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final AppConfig _config;

  AnalyticsRepositoryImpl(this._config);

  @override
  Future<void> initialize() async {
    final writeKey = _config.segmentWriteKey;
    if (writeKey == null) {
      return Segment.disable();
    }

    await Segment.config(
      options: SegmentConfig(
        writeKey: writeKey,
        trackApplicationLifecycleEvents: true,
        amplitudeIntegrationEnabled: false,
        debug: kDebugMode,
      ),
    );
  }

  @override
  Future<void> login(String userId, String method) async {
    await Segment.identify(
      userId: userId,
      traits: {
        'loginMethod': method,
      },
    );
  }

  @override
  Future<void> logout() async {
    await Segment.track(eventName: 'logout');
    await Segment.reset();
  }

  @override
  void dailyBriefPage(String briefId) {
    //TODO: Refactor these into AnalyticsEvent constructors
    Fimber.d('dailyBriefPage $briefId');
    _trackPage(
      'Daily Brief',
      {
        'brief_id': briefId,
      },
    );
  }

  @override
  void topicPage(String topicId) {
    Fimber.d('topicPage $topicId');
    _trackPage(
      'Topic',
      {
        'topic_id': topicId,
      },
    );
  }

  @override
  void articlePage(String articleId, [String? topicId]) {
    Fimber.d('articlePage $articleId, topic $topicId');
    _trackPage(
      'Article',
      {
        'article_id': articleId,
        'topic_id': topicId,
      },
    );
  }

  @override
  void exploreAreaPage(String exploreAreaId) {
    Fimber.d('exploreAreaPage $exploreAreaId');
    _trackPage(
      'Explore Area',
      {
        'explore_area_id': exploreAreaId,
      },
    );
  }

  @override
  void page(String name) {
    Fimber.d('page $name');
    _trackPage(name);
  }

  @override
  void pageV2(AnalyticsPage page) {
    Fimber.d('$page');
    Segment.screen(screenName: page.name, properties: page.properties);
  }

  @override
  void event(AnalyticsEvent event) {
    // Fimber calls will be removed in the last tracking issue PR
    Fimber.d('$event');
    Segment.track(eventName: event.name, properties: event.properties);
  }

  void _trackPage(String name, [Map<String, dynamic>? properties]) {
    Segment.screen(screenName: name, properties: properties);
  }
}
