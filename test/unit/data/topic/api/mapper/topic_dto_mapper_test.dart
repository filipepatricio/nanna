import 'package:better_informed_mobile/data/topic/api/mapper/topic_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/util/mock_dto_creators.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/entry.dart';
import 'package:better_informed_mobile/domain/image/data/image.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_owner.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_publisher_information.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_summary.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../../generated_mocks.mocks.dart';

void main() {
  late MockImageDTOMapper imageDTOMapper;
  late MockEntryDTOMapper entryDTOMapper;
  late MockSummaryCardDTOMapper summaryCardDTOMapper;
  late MockTopicPublisherInformationDTOMapper topicPublisherInformationDTOMapper;
  late MockTopicOwnerDTOMapper topicOwnerDTOMapper;
  late TopicDTOMapper mapper;

  setUp(() {
    imageDTOMapper = MockImageDTOMapper();
    entryDTOMapper = MockEntryDTOMapper();
    summaryCardDTOMapper = MockSummaryCardDTOMapper();
    topicPublisherInformationDTOMapper = MockTopicPublisherInformationDTOMapper();
    topicOwnerDTOMapper = MockTopicOwnerDTOMapper();
    mapper = TopicDTOMapper(
      imageDTOMapper,
      entryDTOMapper,
      summaryCardDTOMapper,
      topicPublisherInformationDTOMapper,
      topicOwnerDTOMapper,
    );
  });

  test('maps dto to domain object', () {
    final dto = MockDTO.topic;

    final owner = FakeTopicOwner();
    final publisherInformation = FakeTopicPublisherInformation();
    final entry = FakeEntry();
    final entries = [entry, entry, entry];
    final summaryCard = FakeSummaryCard();
    final summaryCards = [
      summaryCard,
      summaryCard,
    ];
    final heroImage = FakeImage();

    final expected = Topic(
      id: 'topic-id',
      slug: 'topic-slug',
      title: 'Lorem ipsum **dolor sit** amet, consectetur adip',
      strippedTitle: 'Lorem ipsum dolor sit amet, consectetur adip',
      introduction:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
      url: 'url',
      owner: owner,
      lastUpdatedAt: DateTime.utc(2021, 12, 23, 11, 38, 26).toLocal(),
      topicSummaryList: summaryCards,
      publisherInformation: publisherInformation,
      heroImage: heroImage,
      entries: entries,
      visited: false,
    );

    when(topicOwnerDTOMapper(dto.owner)).thenAnswer((realInvocation) => owner);
    when(topicPublisherInformationDTOMapper(any)).thenAnswer((realInvocation) => publisherInformation);
    when(entryDTOMapper(any)).thenAnswer((realInvocation) => entry);
    when(summaryCardDTOMapper(any)).thenAnswer((realInvocation) => summaryCard);
    when(imageDTOMapper(dto.heroImage)).thenAnswer((realInvocation) => heroImage);

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
          .having((preview) => preview.owner, 'owner', expected.owner)
          .having((preview) => preview.topicSummaryList, 'topicSummaryList', expected.topicSummaryList)
          .having((preview) => preview.entries, 'readingList', expected.entries)
          .having((preview) => preview.lastUpdatedAt, 'lastUpdatedAt', expected.lastUpdatedAt)
          .having((preview) => preview.publisherInformation, 'highlightedPublishers', expected.publisherInformation)
          .having((preview) => preview.heroImage, 'heroImage', expected.heroImage),
    );
  });
}

class FakeTopicOwner extends Fake implements TopicOwner {}

class FakeImage extends Fake implements Image {}

class FakeEntry extends Fake implements Entry {}

class FakeSummaryCard extends Fake implements TopicSummary {}

class FakeTopicPublisherInformation extends Fake implements TopicPublisherInformation {}
