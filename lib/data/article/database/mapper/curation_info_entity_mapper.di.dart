import 'package:better_informed_mobile/data/article/database/entity/curation_info_entity.hv.dart';
import 'package:better_informed_mobile/data/article/database/mapper/curator_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/bidirectional_mapper.dart';
import 'package:better_informed_mobile/domain/common/data/curation_info.dart';
import 'package:injectable/injectable.dart';

@injectable
class CurationInfoEntityMapper extends BidirectionalMapper<CurationInfoEntity, CurationInfo> {
  CurationInfoEntityMapper(this._curatorEntityMapper);

  final CuratorEntityMapper _curatorEntityMapper;

  @override
  CurationInfoEntity from(CurationInfo data) {
    return CurationInfoEntity(
      byline: data.byline,
      curator: _curatorEntityMapper.from(data.curator),
    );
  }

  @override
  CurationInfo to(CurationInfoEntity data) {
    return CurationInfo(
      data.byline,
      _curatorEntityMapper.to(data.curator),
    );
  }
}
