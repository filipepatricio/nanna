import 'package:freezed_annotation/freezed_annotation.dart';

part 'release_note_media.dt.freezed.dart';

@Freezed(toJson: false)
class ReleaseNoteMedia with _$ReleaseNoteMedia {
  factory ReleaseNoteMedia.image(String url) = _ReleaseNoteMediaImage;

  factory ReleaseNoteMedia.video(String url) = _ReleaseNoteMediaVideo;
}
