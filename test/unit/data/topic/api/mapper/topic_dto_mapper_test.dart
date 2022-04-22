import 'package:better_informed_mobile/data/topic/api/mapper/topic_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/util/mock_dto_creators.dart';
import 'package:better_informed_mobile/domain/article/data/publisher.dart';
import 'package:better_informed_mobile/domain/image/data/image.dart';
import 'package:better_informed_mobile/domain/topic/data/reading_list.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_owner.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_summary.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../../generated_mocks.mocks.dart';

void main() {
  late MockImageDTOMapper imageDTOMapper;
  late MockReadingListDTOMapper readingListDTOMapper;
  late MockSummaryCardDTOMapper summaryCardDTOMapper;
  late MockPublisherDTOMapper publisherDTOMapper;
  late MockTopicOwnerDTOMapper topicOwnerDTOMapper;
  late TopicDTOMapper mapper;

  setUp(() {
    imageDTOMapper = MockImageDTOMapper();
    readingListDTOMapper = MockReadingListDTOMapper();
    summaryCardDTOMapper = MockSummaryCardDTOMapper();
    publisherDTOMapper = MockPublisherDTOMapper();
    topicOwnerDTOMapper = MockTopicOwnerDTOMapper();
    mapper = TopicDTOMapper(
      imageDTOMapper,
      readingListDTOMapper,
      summaryCardDTOMapper,
      publisherDTOMapper,
      topicOwnerDTOMapper,
    );
  });

  test('maps dto to domain object', () {
    final dto = MockDTO.topic;

    final owner = FakeTopicOwner();
    final publisher = FakePublisher();
    final publishers = [
      publisher,
      publisher,
    ];
    final readingList = FakeReadingList();
    final summaryCard = FakeSummaryCard();
    final summaryCards = [
      summaryCard,
      summaryCard,
    ];
    final heroImage = FakeImage();
    final coverImage = FakeImage();

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
      highlightedPublishers: publishers,
      heroImage: heroImage,
      coverImage: coverImage,
      readingList: readingList,
    );

    when(topicOwnerDTOMapper(dto.owner)).thenAnswer((realInvocation) => owner);
    when(publisherDTOMapper(any)).thenAnswer((realInvocation) => publisher);
    when(readingListDTOMapper(dto.readingList)).thenAnswer((realInvocation) => readingList);
    when(summaryCardDTOMapper(any)).thenAnswer((realInvocation) => summaryCard);
    when(imageDTOMapper(dto.heroImage)).thenAnswer((realInvocation) => heroImage);
    when(imageDTOMapper(dto.coverImage)).thenAnswer((realInvocation) => coverImage);

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
          .having((preview) => preview.readingList, 'readingList', expected.readingList)
          .having((preview) => preview.lastUpdatedAt, 'lastUpdatedAt', expected.lastUpdatedAt)
          .having((preview) => preview.highlightedPublishers, 'highlightedPublishers', expected.highlightedPublishers)
          .having((preview) => preview.heroImage, 'heroImage', expected.heroImage)
          .having((preview) => preview.coverImage, 'coverImage', expected.coverImage),
    );
  });
}

class FakeTopicOwner extends Fake implements TopicOwner {}

class FakePublisher extends Fake implements Publisher {}

class FakeImage extends Fake implements Image {}

class FakeReadingList extends Fake implements ReadingList {}

class FakeSummaryCard extends Fake implements TopicSummary {}
