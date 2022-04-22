import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_item.dt.freezed.dart';

@freezed
class AudioItem with _$AudioItem {
  factory AudioItem({
    required String id,
    required String slug,
    required String title,
    required String author,
    required String? imageUrl,
  }) = _AudioItem;
}
