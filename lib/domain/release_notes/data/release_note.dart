import 'package:better_informed_mobile/domain/release_notes/data/release_note_media.dt.dart';

class ReleaseNote {
  ReleaseNote({
    required this.headline,
    required this.content,
    required this.date,
    required this.media,
    required this.version,
  });

  final String headline;
  final String content;
  final DateTime date;
  final List<ReleaseNoteMedia> media;
  final String version;
}
