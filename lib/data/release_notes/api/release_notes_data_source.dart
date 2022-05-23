import 'package:better_informed_mobile/data/release_notes/dto/release_note_dto.dt.dart';

abstract class ReleaseNotesDataSource {
  Future<ReleaseNoteDTO?> getReleaseNote(String version);
}
