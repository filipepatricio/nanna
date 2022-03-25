import 'package:audio_service/audio_service.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/audio/data/audio_item.dart';
import 'package:injectable/injectable.dart';

@injectable
class AudioMediaItemMapper implements Mapper<AudioItem, MediaItem> {
  @override
  MediaItem call(AudioItem data) {
    final imageUrl = data.imageUrl;

    return MediaItem(
      id: data.file.path,
      title: data.title,
      artist: data.publisher,
      artUri: imageUrl == null ? null : Uri.parse(imageUrl),
    );
  }
}
