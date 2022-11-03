import 'package:better_informed_mobile/data/common/dto/curator_dto.dt.dart';
import 'package:better_informed_mobile/data/image/api/mapper/image_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/common/data/curator.dt.dart';
import 'package:injectable/injectable.dart';

@injectable
class CuratorDTOMapper implements Mapper<CuratorDTO, Curator> {
  CuratorDTOMapper(this._imageDTOMapper);

  final ImageDTOMapper _imageDTOMapper;

  @override
  Curator call(CuratorDTO data) {
    return data.map(
      expert: (data) => Curator.expert(
        id: data.id,
        name: data.name,
        bio: data.bio,
        areaOfExpertise: data.areaOfExpertise,
        instagram: data.instagram,
        linkedin: data.linkedin,
        website: data.website,
        twitter: data.twitter,
        avatar: data.avatar != null ? _imageDTOMapper(data.avatar!) : null,
      ),
      editor: (data) => Curator.editor(
        id: data.id,
        name: data.name,
        bio: data.bio,
        avatar: data.avatar != null ? _imageDTOMapper(data.avatar!) : null,
      ),
      editorialTeam: (data) => Curator.editorialTeam(
        name: data.name,
        bio: data.bio,
      ),
      unknown: (data) => Curator.unknown(),
    );
  }
}
