import 'package:better_informed_mobile/data/daily_brief/api/mapper/image_dto_mapper.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/data/topic/api/dto/topic_owner_dto.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_owner.dart';
import 'package:injectable/injectable.dart';

@injectable
class TopicOwnerDTOMapper implements Mapper<TopicOwnerDTO, TopicOwner> {
  final ImageDTOMapper _imageDTOMapper;

  TopicOwnerDTOMapper(this._imageDTOMapper);

  @override
  TopicOwner call(TopicOwnerDTO data) {
    return data.map(
      expert: (data) => Expert(
        id: data.id,
        name: data.name,
        bio: data.bio,
        areaOfExpertise: data.areaOfExpertise,
        instagram: data.instagram,
        linkedin: data.linkedin,
        avatar: data.avatar != null ? _imageDTOMapper(data.avatar!) : null,
      ),
      editor: (data) => Editor(
        name: data.name,
        avatar: data.avatar != null ? _imageDTOMapper(data.avatar!) : null,
      ),
    );
  }
}
