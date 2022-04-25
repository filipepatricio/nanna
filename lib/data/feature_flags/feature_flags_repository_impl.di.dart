import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/feature_flags/feature_flags_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:launchdarkly_flutter_client_sdk/launchdarkly_flutter_client_sdk.dart';

@LazySingleton(as: FeaturesFlagsRepository, env: liveEnvs)
class FeatureFlagsRepositoryImpl implements FeaturesFlagsRepository {
  const FeatureFlagsRepositoryImpl(this._config);

  final AppConfig _config;

  @override
  Future<void> initialize(String uuid, String email, String firstName, String lastName) async {
    final launchDarklyKey = _config.launchDarklyKey;

    if (launchDarklyKey != null) {
      final config =
          LDConfigBuilder(launchDarklyKey).connectionTimeoutMillis(5000).eventsFlushIntervalMillis(5000).build();

      final user = LDUserBuilder(uuid).email(email).firstName(firstName).lastName(lastName).build();

      // If the user already exists in LaunchDarkly, this call also updates their profile values
      await LDClient.start(config, user);

      // To make sure the SDK is initialized (mainly for flags that affect the root navigator)
      await LDClient.startFuture(timeLimit: const Duration(seconds: 5));
    }
  }
}
