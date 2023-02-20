import 'package:better_informed_mobile/data/topic/api/mapper/topic_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/util/mock_dto_creators.dart';
import 'package:better_informed_mobile/domain/common/data/curation_info.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/entry.dart';
import 'package:better_informed_mobile/domain/image/data/image.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_publisher_information.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../../../generated_mocks.mocks.dart';
import '../../../../../../test_data.dart';

void main() {
  late MockImageDTOMapper imageDTOMapper;
  late MockEntryDTOMapper entryDTOMapper;
  late MockTopicPublisherInformationDTOMapper topicPublisherInformationDTOMapper;
  late MockCurationInfoDTOMapper curationInfoDTOMapper;
  late TopicDTOMapper mapper;
  late MockCategoryDTOMapper categoryDTOMapper;

  setUp(() {
    imageDTOMapper = MockImageDTOMapper();
    entryDTOMapper = MockEntryDTOMapper();
    topicPublisherInformationDTOMapper = MockTopicPublisherInformationDTOMapper();
    curationInfoDTOMapper = MockCurationInfoDTOMapper();
    categoryDTOMapper = MockCategoryDTOMapper();
    mapper = TopicDTOMapper(
      imageDTOMapper,
      entryDTOMapper,
      topicPublisherInformationDTOMapper,
      categoryDTOMapper,
      curationInfoDTOMapper,
    );
  });

  test('maps dto to domain object', () {
    final dto = MockDTO.topic;

    final curationInfo = FakeCurationInfo();
    final publisherInformation = FakeTopicPublisherInformation();
    final entry = FakeEntry();
    final entries = [entry, entry, entry];
    final heroImage = FakeImage();

    final expected = Topic(
      id: 'topic-id',
      slug: 'topic-slug',
      title: 'Lorem ipsum **dolor sit** amet, consectetur adip',
      strippedTitle: 'Lorem ipsum dolor sit amet, consectetur adip',
      introduction:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
      ownersNote: 'Consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
      url: 'url',
      curationInfo: curationInfo,
      lastUpdatedAt: DateTime.utc(2021, 12, 23, 11, 38, 26).toLocal(),
      summary:
          '* Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do onsectetur adipisci  elit, sed do nsectetur adipisci  elit, sed do \n'
          '* Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do onsectetur adipisci  elit, sed do nsectetur adipisci  elit, sed do \n'
          '* Lorem ipsum dolor sit amet, consectetur adipisci  elit, sed do onsectetur adipisci  elit, sed do nsectetur adipisci  elit, sed do ',
      publisherInformation: publisherInformation,
      heroImage: heroImage,
      entries: entries,
      visited: false,
      category: TestData.category,
    );

    when(curationInfoDTOMapper(dto.curationInfo)).thenAnswer((realInvocation) => curationInfo);
    when(topicPublisherInformationDTOMapper(any)).thenAnswer((realInvocation) => publisherInformation);
    when(entryDTOMapper(any)).thenAnswer((realInvocation) => entry);
    when(imageDTOMapper(dto.heroImage)).thenAnswer((realInvocation) => heroImage);
    when(categoryDTOMapper(dto.category)).thenAnswer((realInvocation) => TestData.category);

    final actual = mapper(dto);

    expect(
      actual,
      isA<Topic>()
          .having((preview) => preview.id, 'id', expected.id)
          .having((preview) => preview.slug, 'slug', expected.slug)
          .having((preview) => preview.title, 'title', expected.title)
          .having((preview) => preview.strippedTitle, 'strippedTitle', expected.strippedTitle)
          .having((preview) => preview.introduction, 'introduction', expected.introduction)
          .having((preview) => preview.url, 'url', expected.url)
          .having((preview) => preview.curationInfo, 'curationInfo', expected.curationInfo)
          .having((preview) => preview.entries, 'readingList', expected.entries)
          .having((preview) => preview.lastUpdatedAt, 'lastUpdatedAt', expected.lastUpdatedAt)
          .having((preview) => preview.publisherInformation, 'highlightedPublishers', expected.publisherInformation)
          .having((preview) => preview.heroImage, 'heroImage', expected.heroImage),
    );
  });
}

class FakeCurationInfo extends Fake implements CurationInfo {}

class FakeImage extends Fake implements Image {}

class FakeEntry extends Fake implements Entry {}

class FakeTopicPublisherInformation extends Fake implements TopicPublisherInformation {}
