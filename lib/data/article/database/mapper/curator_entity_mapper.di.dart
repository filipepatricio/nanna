import 'package:better_informed_mobile/data/article/database/entity/curator_entity.hv.dart';
import 'package:better_informed_mobile/data/article/database/mapper/image_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/bidirectional_mapper.dart';
import 'package:better_informed_mobile/domain/common/data/curator.dt.dart';
import 'package:injectable/injectable.dart';

@injectable
class CuratorEntityMapper extends BidirectionalMapper<CuratorEntity, Curator> {
  CuratorEntityMapper(this._imageEntityMapper);

  final ImageEntityMapper _imageEntityMapper;

  @override
  CuratorEntity from(Curator data) {
    return data.map(
      editor: (curator) {
        final avatar = curator.avatar;

        return CuratorEntity.editor(
          CuratorEditorEntity(
            id: curator.id,
            name: curator.name,
            bio: curator.bio,
            avatar: avatar != null ? _imageEntityMapper.from(avatar) : null,
          ),
        );
      },
      expert: (curator) {
        final avatar = curator.avatar;

        return CuratorEntity.expert(
          CuratorExpertEntity(
            id: curator.id,
            name: curator.name,
            bio: curator.bio,
            avatar: avatar != null ? _imageEntityMapper.from(avatar) : null,
            areaOfExpertise: curator.areaOfExpertise,
            instagram: curator.instagram,
            linkedin: curator.linkedin,
            twitter: curator.twitter,
            website: curator.website,
          ),
        );
      },
      editorialTeam: (curator) => CuratorEntity.editorialTeam(
        CuratorEditorialTeamEntity(
          name: curator.name,
          bio: curator.bio,
        ),
      ),
      unknown: (curator) => CuratorEntity.unknown(),
    );
  }

  @override
  Curator to(CuratorEntity data) {
    return data.map(
      editor: (curator) {
        final avatar = curator.avatar;

        return Curator.editor(
          id: curator.id,
          name: curator.name,
          bio: curator.bio,
          avatar: avatar != null ? _imageEntityMapper.to(avatar) : null,
        );
      },
      expert: (curator) {
        final avatar = curator.avatar;

        return Curator.expert(
          id: curator.id,
          name: curator.name,
          bio: curator.bio,
          avatar: avatar != null ? _imageEntityMapper.to(avatar) : null,
          areaOfExpertise: curator.areaOfExpertise,
          instagram: curator.instagram,
          linkedin: curator.linkedin,
          twitter: curator.twitter,
          website: curator.website,
        );
      },
      editorialTeam: (curator) => Curator.editorialTeam(
        name: curator.name,
        bio: curator.bio,
      ),
      unknown: (curator) => Curator.unknown(),
    );
  }
}
