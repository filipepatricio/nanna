import 'package:better_informed_mobile/data/feature_flags/data/feature_flag_data.dt.dart';
import 'package:better_informed_mobile/domain/analytics/data/install_attribution_payload.dt.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/feature_flags/feature_flags_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: FeaturesFlagsRepository, env: mockEnvs)
class FeatureFlagsRepositoryMock implements FeaturesFlagsRepository {
  const FeatureFlagsRepositoryMock();

  @override
  Future<void> initialize(FeatureFlagData data) async {
    return;
  }

  @override
  Future<String> initialTab() async {
    return '';
  }

  @override
  Future<bool> usePaidSubscriptions() async {
    return false;
  }

  @override
  Future<void> setupAttribution(InstallAttributionPayload installAttributionPayload) async {}
}
