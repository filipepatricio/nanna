import 'package:better_informed_mobile/data/topic/api/mapper/topic_preview_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/util/mock_dto_creators.dart';
import 'package:better_informed_mobile/domain/image/data/image.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_owner.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_publisher_information.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../../generated_mocks.mocks.dart';

void main() {
  late MockTopicOwnerDTOMapper topicOwnerDTOMapper;
  late MockTopicPublisherInformationDTOMapper topicPublisherInformationDTOMapper;
  late MockImageDTOMapper imageDTOMapper;
  late TopicPreviewDTOMapper mapper;

  setUp(() {
    topicOwnerDTOMapper = MockTopicOwnerDTOMapper();
    topicPublisherInformationDTOMapper = MockTopicPublisherInformationDTOMapper();
    imageDTOMapper = MockImageDTOMapper();
    mapper = TopicPreviewDTOMapper(
      topicOwnerDTOMapper,
      topicPublisherInformationDTOMapper,
      imageDTOMapper,
    );
  });

  test('maps dto to domain object', () {
    final dto = MockDTO.topicPreview;

    final owner = FakeTopicOwner();
    final publisherInformation = FakeTopicPublisherInformation();
    final heroImage = FakeImage();
    final expected = TopicPreview(
      'topic-id',
      'topic-slug',
      'Lorem ipsum **dolor sit** amet, consectetur adip',
      'Lorem ipsum dolor sit amet, consectetur adip',
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
      'url',
      owner,
      DateTime.utc(2021, 12, 23, 11, 38, 26).toLocal(),
      publisherInformation,
      heroImage,
      3,
      false,
    );

    when(topicOwnerDTOMapper(dto.owner)).thenAnswer((realInvocation) => owner);
    when(topicPublisherInformationDTOMapper(any)).thenAnswer((realInvocation) => publisherInformation);
    when(imageDTOMapper(dto.heroImage)).thenAnswer((realInvocation) => heroImage);

    final actual = mapper(dto);

    expect(
      actual,
      isA<TopicPreview>()
          .having((preview) => preview.id, 'id', expected.id)
          .having((preview) => preview.slug, 'slug', expected.slug)
          .having((preview) => preview.title, 'title', expected.title)
          .having((preview) => preview.strippedTitle, 'strippedTitle', expected.strippedTitle)
          .having((preview) => preview.introduction, 'introduction', expected.introduction)
          .having((preview) => preview.url, 'url', expected.url)
          .having((preview) => preview.owner, 'owner', expected.owner)
          .having((preview) => preview.lastUpdatedAt, 'lastUpdatedAt', expected.lastUpdatedAt)
          .having((preview) => preview.publisherInformation, 'highlightedPublishers', expected.publisherInformation)
          .having((preview) => preview.heroImage, 'heroImage', expected.heroImage)
          .having((preview) => preview.entryCount, 'entryCount', expected.entryCount),
    );
  });
}

class FakeTopicOwner extends Fake implements TopicOwner {}

class FakeImage extends Fake implements Image {}

class FakeTopicPublisherInformation extends Fake implements TopicPublisherInformation {}
