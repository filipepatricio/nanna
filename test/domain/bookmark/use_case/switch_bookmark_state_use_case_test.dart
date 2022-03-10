import 'package:better_informed_mobile/domain/analytics/analytics_repository.dart';
import 'package:better_informed_mobile/domain/bookmark/bookmark_repository.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_state.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_type_data.dart';
import 'package:better_informed_mobile/domain/bookmark/use_case/switch_bookmark_state_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'switch_bookmark_state_use_case_test.mocks.dart';

@GenerateMocks(
  [
    BookmarkRepository,
    AnalyticsRepository,
  ],
)
void main() {
  late MockBookmarkRepository repository;
  late MockAnalyticsRepository analyticsRepository;
  late SwitchBookmarkStateUseCase useCase;

  setUp(() {
    repository = MockBookmarkRepository();
    analyticsRepository = MockAnalyticsRepository();
    useCase = SwitchBookmarkStateUseCase(repository, analyticsRepository);
  });

  group('for article type', () {
    test('it bookmarks when not bookmarked', () async {
      const slug = 'article-slug';
      const id = '0000-0000';
      const articleId = '1111-1111';
      const type = BookmarkTypeData.article(slug, articleId);
      final state = BookmarkState.notBookmarked();
      final expected = BookmarkState.bookmarked(id);

      when(repository.bookmarkArticle(slug)).thenAnswer((_) async => BookmarkState.bookmarked(id));

      final actual = await useCase(type, state);

      expect(actual, expected);

      verifyNever(repository.bookmarkTopic(any));
      verifyNever(repository.removeBookmark(any));
    });

    test('it unbookmarks when bookmarked', () async {
      const slug = 'article-slug';
      const id = '0000-0000';
      const articleId = '1111-1111';
      const type = BookmarkTypeData.article(slug, articleId);
      final state = BookmarkState.bookmarked(id);
      final expected = BookmarkState.notBookmarked();

      when(repository.removeBookmark(id)).thenAnswer((_) async => BookmarkState.notBookmarked());

      final actual = await useCase(type, state);

      expect(actual, expected);

      verifyNever(repository.bookmarkArticle(any));
      verifyNever(repository.bookmarkTopic(any));
    });
  });

  group('for topic type', () {
    test('it bookmarks when not bookmarked', () async {
      const slug = 'topic-slug';
      const id = '0000-0000';
      const topicId = '1111-1111';
      const type = BookmarkTypeData.topic(slug, topicId);
      final state = BookmarkState.notBookmarked();
      final expected = BookmarkState.bookmarked(id);

      when(repository.bookmarkTopic(slug)).thenAnswer((_) async => BookmarkState.bookmarked(id));

      final actual = await useCase(type, state);

      expect(actual, expected);

      verifyNever(repository.bookmarkArticle(any));
      verifyNever(repository.removeBookmark(any));
    });

    test('it unbookmarks when bookmarked', () async {
      const slug = 'topic-slug';
      const id = '0000-0000';
      const topicId = '1111-1111';
      const type = BookmarkTypeData.topic(slug, topicId);
      final state = BookmarkState.bookmarked(id);
      final expected = BookmarkState.notBookmarked();

      when(repository.removeBookmark(id)).thenAnswer((_) async => BookmarkState.notBookmarked());

      final actual = await useCase(type, state);

      expect(actual, expected);

      verifyNever(repository.bookmarkArticle(any));
      verifyNever(repository.bookmarkTopic(any));
    });
  });
}
