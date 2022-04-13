import 'package:audio_service/audio_service.dart';
import 'package:better_informed_mobile/data/bidirectional_mapper.dart';
import 'package:better_informed_mobile/domain/audio/data/audio_item.dt.dart';
import 'package:injectable/injectable.dart';

const slugKey = 'slug';

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
      extras: {
        slugKey: data.slug,
      },
    );
  }

  @override
  AudioItem to(MediaItem data) {
    final slug = data.extras?[slugKey] as String?;

    if (slug == null) throw Exception('MediaItem is missing slug');

    return AudioItem(
      id: data.id,
      slug: slug,
      title: data.title,
      author: data.artist ?? '',
      imageUrl: data.artUri?.toString(),
    );
  }
}
