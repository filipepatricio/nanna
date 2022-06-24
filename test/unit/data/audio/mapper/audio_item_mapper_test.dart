import 'package:audio_service/audio_service.dart';
import 'package:better_informed_mobile/data/audio/mapper/audio_item_mapper.di.dart';
import 'package:better_informed_mobile/domain/audio/data/audio_item.dt.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AudioItemMapper mapper;

  setUp(() {
    mapper = AudioItemMapper();
  });

  group('maps from MediaItem to AudioItem', () {
    test('with image url', () {
      final mediaItem = MediaItem(
        id: '0000',
        title: 'Should you test it',
        artist: 'NYT',
        artUri: Uri.parse('www.image.com/test'),
        extras: {
          slugKey: 'should-you-test-it',
        },
      );
      final expected = AudioItem(
        id: '0000',
        slug: 'should-you-test-it',
        title: 'Should you test it',
        author: 'NYT',
        imageUrl: 'www.image.com/test',
        duration: null,
      );

      final actual = mapper.to(mediaItem);

      expect(actual, expected);
    });

    test('without image url', () {
      const mediaItem = MediaItem(
        id: '0000',
        title: 'Should you test it',
        artist: 'NYT',
        artUri: null,
        extras: {
          slugKey: 'should-you-test-it',
        },
      );
      final expected = AudioItem(
        id: '0000',
        slug: 'should-you-test-it',
        title: 'Should you test it',
        author: 'NYT',
        imageUrl: null,
        duration: null,
      );

      final actual = mapper.to(mediaItem);

      expect(actual, expected);
    });
  });

  group('maps from AudioItem to MediaItem', () {
    test('with image url', () {
      final audioItem = AudioItem(
        id: '0000',
        slug: 'should-you-test-it',
        title: 'Should you test it',
        author: 'NYT',
        imageUrl: 'www.image.com/test',
        duration: null,
      );
      final expected = MediaItem(
        id: '0000',
        title: 'Should you test it',
        artist: 'NYT',
        artUri: Uri.parse('www.image.com/test'),
        extras: {
          slugKey: 'should-you-test-it',
        },
      );

      final actual = mapper.from(audioItem);

      expect(actual, expected);
    });

    test('without image url', () {
      final audioItem = AudioItem(
        id: '0000',
        slug: 'should-you-test-it',
        title: 'Should you test it',
        author: 'NYT',
        imageUrl: null,
        duration: null,
      );
      const expected = MediaItem(
        id: '0000',
        title: 'Should you test it',
        artist: 'NYT',
        artUri: null,
        extras: {
          slugKey: 'should-you-test-it',
        },
      );

      final actual = mapper.from(audioItem);

      expect(actual, expected);
    });
  });
}
