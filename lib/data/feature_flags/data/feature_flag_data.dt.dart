import 'package:better_informed_mobile/domain/analytics/data/install_attribution_payload.dt.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'feature_flag_data.dt.freezed.dart';

@freezed
class FeatureFlagData with _$FeatureFlagData {
  factory FeatureFlagData({
    required String uuid,
    required String email,
    required String firstName,
    required String lastName,
    required String client,
    required String clientVersion,
    required String clientPlatform,
    InstallAttributionPayload? attributionPayload,
  }) = _FeatureFlagData;
}
