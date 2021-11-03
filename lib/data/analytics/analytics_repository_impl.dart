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
}
