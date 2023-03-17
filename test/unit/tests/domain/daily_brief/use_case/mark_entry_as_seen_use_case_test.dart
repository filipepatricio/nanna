import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry_item.dt.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry_style.dart';
import 'package:better_informed_mobile/domain/daily_brief/use_case/mark_entry_as_seen_use_case.di.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../../generated_mocks.mocks.dart';
import '../../../../../test_data.dart';

void main() {
  late MockTopicsRepository topicsRepository;
  late MockArticleRepository articleRepository;
  late MockSaveSeenEntryLocallyUseCase saveSeenItemLocallyUseCase;
  late MockBriefEntryNewStateNotifier mockBriefEntryNewStateNotifier;
  late MockDecreaseBriefUnseenCountStateNotifierUseCase decreaseBriefUnseenCountStateNotifierUseCase;
  late MarkEntryAsSeenUseCase useCase;

  setUp(() {
    topicsRepository = MockTopicsRepository();
    articleRepository = MockArticleRepository();
    saveSeenItemLocallyUseCase = MockSaveSeenEntryLocallyUseCase();
    mockBriefEntryNewStateNotifier = MockBriefEntryNewStateNotifier();
    decreaseBriefUnseenCountStateNotifierUseCase = MockDecreaseBriefUnseenCountStateNotifierUseCase();
    useCase = MarkEntryAsSeenUseCase(
      topicsRepository,
      articleRepository,
      saveSeenItemLocallyUseCase,
      mockBriefEntryNewStateNotifier,
      decreaseBriefUnseenCountStateNotifierUseCase,
    );
  });

  test('marks article as seen', () async {
    final article = TestData.article;
    final item = BriefEntryItem.article(article: article);
    final entry = BriefEntry(
      item: item,
      style: const BriefEntryStyle(
        backgroundColor: null,
        type: BriefEntryStyleType.articleCardLarge,
      ),
      isNew: false,
    );

    when(articleRepository.markArticleAsSeen(article.slug)).thenAnswer((_) async => true);

    await useCase(entry);

    verify(articleRepository.markArticleAsSeen(article.slug));
  });

  test('marks topic as seen', () async {
    final topic = TestData.topic.asPreview;
    final item = BriefEntryItem.topicPreview(topicPreview: topic);
    final entry = BriefEntry(
      item: item,
      style: const BriefEntryStyle(
        backgroundColor: null,
        type: BriefEntryStyleType.topicCard,
      ),
      isNew: false,
    );

    when(topicsRepository.markTopicAsSeen(topic.slug)).thenAnswer((_) async => true);

    await useCase(entry);

    verify(topicsRepository.markTopicAsSeen(topic.slug));
  });
}
