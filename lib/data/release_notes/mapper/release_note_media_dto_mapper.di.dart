import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/data/release_notes/dto/release_note_media_dto.dt.dart';
import 'package:better_informed_mobile/domain/release_notes/data/release_note_media.dt.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';

@injectable
class ReleaseNoteMediaDTOMapper implements Mapper<ReleaseNoteMediaDTO, ReleaseNoteMedia?> {
  @override
  ReleaseNoteMedia? call(ReleaseNoteMediaDTO data) {
    return data.map(
      png: (data) => ReleaseNoteMedia.image(data.url),
      mp4: (data) => ReleaseNoteMedia.video(data.url),
      unknown: (data) {
        Fimber.w('Unknown release note media format: ${data.format}');
        return null;
      },
    );
  }
}
