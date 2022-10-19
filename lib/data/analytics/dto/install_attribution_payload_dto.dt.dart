// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'install_attribution_payload_dto.dt.freezed.dart';
part 'install_attribution_payload_dto.dt.g.dart';

@Freezed(unionKey: 'af_status', toJson: false)
class InstallAttributionPayloadDTO with _$InstallAttributionPayloadDTO {
  @FreezedUnionValue('Organic')
  factory InstallAttributionPayloadDTO.organic() = _InstallAttributionPayloadDTOOrganic;

  @FreezedUnionValue('Non-organic')
  factory InstallAttributionPayloadDTO.nonOrganic(
    @JsonKey(name: 'campaign') String campaign,
    @JsonKey(name: 'media_source') String mediaSource,
    @JsonKey(name: 'adset') String? adset,
  ) = _InstallAttributionPayloadDTONonOrganic;

  factory InstallAttributionPayloadDTO.fromJson(Map<String, dynamic> json) =>
      _$InstallAttributionPayloadDTOFromJson(json);
}
