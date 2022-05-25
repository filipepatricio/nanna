import 'package:better_informed_mobile/domain/release_notes/data/release_note.dart';

abstract class ReleaseNotesRemoteRepository {
  Future<ReleaseNote?> getReleaseNote(String version);
}
