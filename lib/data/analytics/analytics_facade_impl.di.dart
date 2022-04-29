import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_facade.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_page.dt.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:flutter_segment/flutter_segment.dart';
import 'package:injectable/injectable.dart';
import 'package:launchdarkly_flutter_client_sdk/launchdarkly_flutter_client_sdk.dart';

@LazySingleton(as: AnalyticsFacade, env: liveEnvs)
class AnalyticsFacadeImpl implements AnalyticsFacade {
  AnalyticsFacadeImpl();

  @override
  Future<void> config(String writeKey) async {
    return await Segment.config(
      options: SegmentConfig(
        writeKey: writeKey,
        trackApplicationLifecycleEvents: true,
        amplitudeIntegrationEnabled: false,
      ),
    );
  }

  @override
  Future<void> identify(String userId, String method) async {
    return await Segment.identify(
      userId: userId,
      traits: {
        'loginMethod': method,
      },
    );
  }

  @override
  void page(AnalyticsPage page) {
    Segment.screen(screenName: page.name, properties: page.properties);
    LDClient.track('${page.name} Screen View', data: _tryGenerateTrackData(page.properties));
  }

  @override
  Future<void> event(AnalyticsEvent event) async {
    await Segment.track(eventName: event.name, properties: event.properties);
    await LDClient.track(event.name, data: _tryGenerateTrackData(event.properties));
  }

  @override
  Future<void> reset() async {
    return await Segment.reset();
  }

  @override
  Future<void> disable() {
    return Segment.disable();
  }

  LDValue? _tryGenerateTrackData(Map<String, dynamic>? properties) {
    if (properties == null || properties.isEmpty) {
      return null;
    }

    final objectBuilder = LDValue.buildObject();

    for (final entry in properties.entries) {
      try {
        switch (entry.value.runtimeType) {
          case bool:
            objectBuilder.addBool(entry.key, entry.value as bool);
            break;
          case num:
            objectBuilder.addNum(entry.key, entry.value as num);
            break;
          default:
            objectBuilder.addString(entry.key, entry.value.toString());
        }
      } catch (_) {
        objectBuilder.addString(entry.key, entry.value.toString());
      }
    }
    return objectBuilder.build();
  }
}
