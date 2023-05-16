import 'dart:async';

import 'package:better_informed_mobile/data/feature_flags/data/feature_flag_data.dt.dart';
import 'package:better_informed_mobile/domain/analytics/data/install_attribution_payload.dt.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/feature_flags/feature_flags_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:launchdarkly_flutter_client_sdk/launchdarkly_flutter_client_sdk.dart';

const clientKey = 'client';
const clientVersionKey = 'clientVersion';
const clientPlatformKey = 'clientPlatform';

const attributionStatusKey = 'afStatus';
const attributionCampaignKey = 'afCampaign';
const attributionMediaSourceKey = 'afMediaSource';
const attributionAdSet = 'afAdset';

const _useObservableQueriesFlag = 'use-observable-queries';
const _useTextSizeSelectorFlag = 'use-text-size-selector';

const _rootRouteFlag = 'root-route';
const _rootRouteFlagDefaultValue = '';

const _paywallFlag = 'paywall';
const _paywallFlagDefaultValue = 'current';

@LazySingleton(as: FeaturesFlagsRepository, env: defaultEnvs)
class FeatureFlagsRepositoryImpl implements FeaturesFlagsRepository {
  FeatureFlagsRepositoryImpl(this._config);

  final AppConfig _config;

  FeatureFlagData? _data;

  @override
  Future<void> initialize(FeatureFlagData data) async {
    _data = data;

    final launchDarklyKey = _config.launchDarklyKey;

    if (launchDarklyKey != null) {
      final config =
          LDConfigBuilder(launchDarklyKey).connectionTimeoutMillis(5000).eventsFlushIntervalMillis(5000).build();

      final user = _buildUser(data);

      // If the user already exists in LaunchDarkly, this call also updates their profile values
      await LDClient.start(config, user);

      // To make sure the SDK is initialized (mainly for flags that affect the root navigator)
      await LDClient.startFuture(timeLimit: const Duration(seconds: 5));
    }
  }

  @override
  Future<String> initialTab() async {
    return await _fetchFlag<String>(_rootRouteFlag, _rootRouteFlagDefaultValue);
  }

  @override
  Future<String> defaultPaywall() async {
    return await _fetchFlag<String>(_paywallFlag, _paywallFlagDefaultValue);
  }

  @override
  Future<bool> useObservableQueries() async {
    return await _fetchFlag<bool>(_useObservableQueriesFlag, true);
  }

  @override
  Future<bool> useTextSizeSelector() async {
    return await _fetchFlag<bool>(_useTextSizeSelectorFlag, true);
  }

  @override
  Future<void> setupAttribution(InstallAttributionPayload installAttributionPayload) async {
    final data = _data;

    if (data != null) {
      final dataWithAttribution = data.copyWith(attributionPayload: installAttributionPayload);
      final updatedUser = _buildUser(dataWithAttribution);

      await LDClient.identify(updatedUser);

      _data = dataWithAttribution;
    }
  }

  LDUser _buildUser(FeatureFlagData data) {
    final builder = LDUserBuilder(data.uuid)
        .email(data.email)
        .firstName(data.firstName)
        .lastName(data.lastName)
        .custom(clientKey, LDValue.ofString(data.client))
        .custom(clientVersionKey, LDValue.ofString(data.clientVersion))
        .custom(clientPlatformKey, LDValue.ofString(data.clientPlatform));

    final attribution = data.attributionPayload;
    if (attribution != null) {
      attribution.map(
        organic: (attribution) {
          builder.custom(attributionStatusKey, LDValue.ofString('Organic'));
        },
        nonOrganic: (attribution) {
          builder.custom(attributionStatusKey, LDValue.ofString('Non-organic'));
          builder.custom(attributionCampaignKey, LDValue.ofString(attribution.campaign));
          builder.custom(attributionMediaSourceKey, LDValue.ofString(attribution.mediaSource));
          builder.custom(attributionAdSet, LDValue.ofString(attribution.adset));
        },
      );
    }

    return builder.build();
  }

  Future<T> _fetchFlag<T>(String flagKey, T defaultValue) async {
    if (!LDClient.isInitialized()) {
      return defaultValue;
    }

    switch (T) {
      case String:
        final flagValue = await LDClient.stringVariation(flagKey, defaultValue as String);
        return flagValue as T;
      case bool:
        final flagValue = await LDClient.boolVariation(flagKey, defaultValue as bool);
        return flagValue as T;
      default:
        throw Exception('Unsupported flag type $T');
    }
  }
}
