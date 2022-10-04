import 'package:better_informed_mobile/data/feature_flags/data/feature_flag_data.dt.dart';
import 'package:better_informed_mobile/domain/analytics/data/install_attribution_payload.dt.dart';

abstract class FeaturesFlagsRepository {
  Future<void> initialize(FeatureFlagData data);

  Future<void> setupAttribution(InstallAttributionPayload installAttributionPayload);

  Future<String> initialTab();

  Future<bool> usePaidSubscriptions();

  Stream<bool> usePaidSubscriptionStream();
}
