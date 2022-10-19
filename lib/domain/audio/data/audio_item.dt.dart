import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_item.dt.freezed.dart';

@Freezed(toJson: false)
class AudioItem with _$AudioItem {
  factory AudioItem({
    required String id,
    required String slug,
    required String title,
    required String author,
    required String? imageUrl,
    required Duration? duration,
  }) = _AudioItem;
}
