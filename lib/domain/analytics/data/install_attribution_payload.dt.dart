import 'package:freezed_annotation/freezed_annotation.dart';

part 'install_attribution_payload.dt.freezed.dart';

@Freezed(toJson: false)
class InstallAttributionPayload with _$InstallAttributionPayload {
  factory InstallAttributionPayload.organic() = _InstallAttributionPayloadOrganic;

  factory InstallAttributionPayload.nonOrganic(
    String campaign,
    String mediaSource,
    String? adset,
  ) = _InstallAttributionPayloadNonOrganic;
}
