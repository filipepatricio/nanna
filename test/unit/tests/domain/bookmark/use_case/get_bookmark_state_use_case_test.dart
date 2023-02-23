import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_state.dt.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_type_data.dt.dart';
import 'package:better_informed_mobile/domain/bookmark/use_case/get_bookmark_state_use_case.di.dart';
import 'package:better_informed_mobile/domain/exception/no_internet_connection_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../../generated_mocks.mocks.dart';

void main() {
  late MockBookmarkRepository repository;
  late MockBookmarkLocalRepository localRepository;
  late MockConnectivityRepository connectivityRepository;
  late GetBookmarkStateUseCase useCase;

  setUp(() {
    repository = MockBookmarkRepository();
    localRepository = MockBookmarkLocalRepository();
    connectivityRepository = MockConnectivityRepository();
    useCase = GetBookmarkStateUseCase(repository, localRepository, connectivityRepository);
  });

  const articleSlug = 'article-slug';
  const articleTypeData = BookmarkTypeData.article(articleSlug, '1111-1111', ArticleType.premium);

  const topicSlug = 'topic-slug';
  const topicTypeData = BookmarkTypeData.topic(topicSlug, '1111-1111');

  final bookmarked = BookmarkState.bookmarked('0000-0000');
  final notBookmarked = BookmarkState.notBookmarked();

  test('returns article bookmark state for article type data', () async {
    when(connectivityRepository.hasInternetConnection()).thenAnswer((_) async => true);
    when(repository.getArticleBookmarkState(articleSlug)).thenAnswer((_) async => bookmarked);

    final actual = await useCase(articleTypeData);

    expect(actual, bookmarked);
    verifyNever(repository.getTopicBookmarkState(any));
  });

  test('returns topic bookmark state for topic type data', () async {
    when(connectivityRepository.hasInternetConnection()).thenAnswer((_) async => true);
    when(repository.getTopicBookmarkState(topicSlug)).thenAnswer((_) async => bookmarked);

    final actual = await useCase(topicTypeData);

    expect(actual, bookmarked);
    verifyNever(repository.getArticleBookmarkState(any));
  });

  group('offline', () {
    test('returns article bookmarked if available locally', () async {
      when(connectivityRepository.hasInternetConnection()).thenAnswer((_) async => false);
      when(repository.getArticleBookmarkState(articleSlug)).thenThrow(NoInternetConnectionException());
      when(localRepository.getBookmarkState(articleSlug)).thenAnswer((_) async => bookmarked);

      final actual = await useCase(articleTypeData);
      expect(actual, bookmarked);
    });

    test('returns topic bookmarked if available locally', () async {
      when(connectivityRepository.hasInternetConnection()).thenAnswer((_) async => false);
      when(repository.getTopicBookmarkState(topicSlug)).thenThrow(NoInternetConnectionException());
      when(localRepository.getBookmarkState(topicSlug)).thenAnswer((_) async => bookmarked);

      final actual = await useCase(topicTypeData);
      expect(actual, bookmarked);
    });

    test('returns article not bookmarked if unavailable locally', () async {
      when(connectivityRepository.hasInternetConnection()).thenAnswer((_) async => false);
      when(repository.getArticleBookmarkState(articleSlug)).thenThrow(NoInternetConnectionException());
      when(localRepository.getBookmarkState(articleSlug)).thenAnswer((_) async => notBookmarked);

      final actual = await useCase(articleTypeData);
      expect(actual, notBookmarked);
    });

    test('returns topic not bookmarked if unavailable locally', () async {
      when(connectivityRepository.hasInternetConnection()).thenAnswer((_) async => false);
      when(repository.getTopicBookmarkState(topicSlug)).thenThrow(NoInternetConnectionException());
      when(localRepository.getBookmarkState(topicSlug)).thenAnswer((_) async => notBookmarked);

      final actual = await useCase(topicTypeData);
      expect(actual, notBookmarked);
    });
  });
}
