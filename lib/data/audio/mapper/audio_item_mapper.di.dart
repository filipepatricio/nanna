import 'package:audio_service/audio_service.dart';
import 'package:better_informed_mobile/data/bidirectional_mapper.dart';
import 'package:better_informed_mobile/domain/audio/data/audio_item.dt.dart';
import 'package:injectable/injectable.dart';

@injectable
class AudioItemMapper implements BidirectionalMapper<MediaItem, AudioItem> {
  @override
  MediaItem from(AudioItem data) {
    final imageUrl = data.imageUrl;
    return MediaItem(
      id: data.id,
      title: data.title,
      artist: data.author,
      artUri: imageUrl == null ? null : Uri.parse(imageUrl),
    );
  }

  @override
  AudioItem to(MediaItem data) {
    return AudioItem(
      id: data.id,
      title: data.title,
      author: data.artist ?? '',
      imageUrl: data.artUri.toString(),
    );
  }
}
