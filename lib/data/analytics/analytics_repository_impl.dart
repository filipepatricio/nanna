import 'dart:developer';

import 'package:better_informed_mobile/domain/analytics/analytics_repository.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
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
  Future<void> dailyBriefPage(String briefId) {
    log('dailyBriefPage $briefId');
    return _trackPage(
      'Daily Brief',
      {
        'brief_id': briefId,
      },
    );
  }

  @override
  Future<void> topicPage(String topicId) {
    log('topicPage $topicId');
    return _trackPage(
      'Topic',
      {
        'topic_id': topicId,
      },
    );
  }

  @override
  Future<void> articlePage(String articleId, [String? topicId]) {
    log('articlePage $articleId, topic $topicId');
    return _trackPage(
      'Article',
      {
        'article_id': articleId,
        'topic_id': topicId,
      },
    );
  }

  @override
  Future<void> exploreAreaPage(String exploreAreaId) {
    log('exploreAreaPage $exploreAreaId');
    return _trackPage(
      'Explore Area',
      {
        'explore_area_id': exploreAreaId,
      },
    );
  }

  @override
  Future<void> page(String name) {
    log('page $name');
    return _trackPage(name);
  }

  Future<void> _trackPage(String name, [Map<String, dynamic>? properties]) =>
      Segment.screen(screenName: name, properties: properties);
}
