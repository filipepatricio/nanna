import 'package:better_informed_mobile/data/analytics/dto/install_attribution_payload_dto.dt.dart';
import 'package:better_informed_mobile/data/bidirectional_mapper.dart';
import 'package:better_informed_mobile/domain/analytics/data/install_attribution_payload.dt.dart';
import 'package:injectable/injectable.dart';

@injectable
class InstallAttributionPayloadMapper
    implements BidirectionalMapper<InstallAttributionPayload, InstallAttributionPayloadDTO> {
  @override
  InstallAttributionPayload from(InstallAttributionPayloadDTO data) {
    return data.map(
      organic: (data) => InstallAttributionPayload.organic(),
      nonOrganic: (data) => InstallAttributionPayload.nonOrganic(
        data.campaign,
        data.mediaSource,
        data.adset,
      ),
    );
  }

  @override
  InstallAttributionPayloadDTO to(InstallAttributionPayload data) {
    return data.map(
      organic: (data) => InstallAttributionPayloadDTO.organic(),
      nonOrganic: (data) => InstallAttributionPayloadDTO.nonOrganic(
        data.campaign,
        data.mediaSource,
        data.adset,
      ),
    );
  }
}
