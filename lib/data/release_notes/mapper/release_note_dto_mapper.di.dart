import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/data/release_notes/dto/release_note_dto.dt.dart';
import 'package:better_informed_mobile/data/release_notes/mapper/release_note_media_dto_mapper.di.dart';
import 'package:better_informed_mobile/domain/release_notes/data/release_note.dart';
import 'package:better_informed_mobile/domain/release_notes/data/release_note_media.dt.dart';
import 'package:injectable/injectable.dart';

@injectable
class ReleaseNoteDTOMapper implements Mapper<ReleaseNoteDTO, ReleaseNote> {
  ReleaseNoteDTOMapper(this._releaseNoteMediaDTOMapper);

  final ReleaseNoteMediaDTOMapper _releaseNoteMediaDTOMapper;

  @override
  ReleaseNote call(ReleaseNoteDTO data) {
    final mediaList = data.media.map(_releaseNoteMediaDTOMapper).whereType<ReleaseNoteMedia>().toList();

    return ReleaseNote(
      headline: data.headline,
      content: data.content,
      date: DateTime.parse(data.date),
      media: mediaList,
      version: data.version,
    );
  }
}
