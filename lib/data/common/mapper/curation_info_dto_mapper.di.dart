import 'package:better_informed_mobile/data/common/dto/curation_info_dto.dt.dart';
import 'package:better_informed_mobile/data/common/mapper/curator_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/common/data/curation_info.dart';
import 'package:injectable/injectable.dart';

@injectable
class CurationInfoDTOMapper implements Mapper<CurationInfoDTO, CurationInfo> {
  CurationInfoDTOMapper(this._curatorDTOMapper);

  final CuratorDTOMapper _curatorDTOMapper;

  @override
  CurationInfo call(CurationInfoDTO data) {
    return CurationInfo(
      data.byline,
      _curatorDTOMapper(data.curator),
    );
  }
}
