import 'dart:async';

import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:better_informed_mobile/data/analytics/dto/install_attribution_data_dto.dt.dart';
import 'package:better_informed_mobile/data/analytics/mapper/install_attribution_payload_mapper.di.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_facade.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_page.dt.dart';
import 'package:better_informed_mobile/domain/analytics/data/install_attribution_payload.dt.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:flutter_segment/flutter_segment.dart';
import 'package:injectable/injectable.dart';
import 'package:launchdarkly_flutter_client_sdk/launchdarkly_flutter_client_sdk.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

@LazySingleton(as: AnalyticsFacade, env: liveEnvs)
class AnalyticsFacadeImpl implements AnalyticsFacade {
  AnalyticsFacadeImpl(
    this._appsflyerSdk,
    this._installAttributionPayloadMapper,
  );

  final AppsflyerSdk _appsflyerSdk;
  final InstallAttributionPayloadMapper _installAttributionPayloadMapper;

  StreamController<String> _deepLinkStream = BehaviorSubject<String>();

  @override
  Future<InstallAttributionPayload?> initializeAttribution() async {
    final completer = Completer<InstallAttributionPayload?>();

    _appsflyerSdk.onInstallConversionData((data) {
      final dto = InstallAttributionDataDTO.fromJson((data as Map).cast<String, dynamic>());
      completer.complete(_installAttributionPayloadMapper.from(dto.payload));
    });

    _appsflyerSdk.onDeepLinking((deepLink) {
      if (deepLink.status == Status.FOUND) {
        final value = deepLink.deepLink?.deepLinkValue;
        if (value != null) {
          return _deepLinkStream.sink.add(value);
        }

        throw Exception('Appslyer deeplink was found but has no value. Deeplink $deepLink');
      }

      throw Exception('Error handling Appsflyer deeplink. Error ${deepLink.status}. Deeplink $deepLink');
    });

    await _appsflyerSdk.initSdk(
      registerConversionDataCallback: true,
      registerOnDeepLinkingCallback: true,
    );

    return completer.future.timeout(const Duration(seconds: 10), onTimeout: () => null);
  }

  @override
  Stream<String> get deepLinkStream => _deepLinkStream.stream;

  @override
  Future<String?> getAppsflyerId() => _appsflyerSdk.getAppsFlyerUID();

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
  Future<void> identify(String userId, [String? method]) async {
    Sentry.configureScope((scope) => scope.setUser(SentryUser(id: userId)));

    if (method == null) return;

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

    final pageEventName = '${page.name} Screen View';
    LDClient.track(pageEventName, data: _tryGenerateTrackData(page.properties));
    _appsflyerSdk.logEvent(pageEventName, page.properties);
  }

  @override
  Future<void> event(AnalyticsEvent event) async {
    await Sentry.addBreadcrumb(Breadcrumb(message: event.name, category: 'event', data: event.properties));
    await Segment.track(eventName: event.name, properties: event.properties);
    await LDClient.track(event.name, data: _tryGenerateTrackData(event.properties));
    await _appsflyerSdk.logEvent(event.name, event.properties);
  }

  @override
  Future<void> reset() async {
    await _deepLinkStream.close();
    _deepLinkStream = StreamController<String>.broadcast();
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
