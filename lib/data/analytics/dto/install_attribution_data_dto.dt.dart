import 'package:better_informed_mobile/data/analytics/dto/install_attribution_payload_dto.dt.dart';
import 'package:json_annotation/json_annotation.dart';

part 'install_attribution_data_dto.dt.g.dart';

@JsonSerializable()
class InstallAttributionDataDTO {
  InstallAttributionDataDTO(this.payload);

  factory InstallAttributionDataDTO.fromJson(Map<String, dynamic> json) => _$InstallAttributionDataDTOFromJson(json);

  final InstallAttributionPayloadDTO payload;

  Map<String, dynamic> toJson() => _$InstallAttributionDataDTOToJson(this);
}
