import 'package:better_informed_mobile/domain/bookmark/bookmark_repository.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_state.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_type_data.dart';
import 'package:better_informed_mobile/domain/bookmark/use_case/get_bookmark_state_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_bookmark_state_use_case_test.mocks.dart';

@GenerateMocks(
  [
    BookmarkRepository,
  ],
)
void main() {
  late MockBookmarkRepository repository;
  late GetBookmarkStateUseCase useCase;

  setUp(() {
    repository = MockBookmarkRepository();
    useCase = GetBookmarkStateUseCase(repository);
  });

  test('returns article bookmark state for article type data', () async {
    const slug = 'article-slug';
    const articleId = '1111-1111';
    const typeData = BookmarkTypeData.article(slug, articleId);
    final expected = BookmarkState.bookmarked('0000-0000');

    when(repository.getArticleBookmarkState(slug)).thenAnswer((_) async => expected);

    final actual = await useCase(typeData);

    expect(actual, expected);
    verifyNever(repository.getTopicBookmarkState(any));
  });

  test('returns topic bookmark state for topic type data', () async {
    const slug = 'topic-slug';
    const topicId = '1111-1111';
    const typeData = BookmarkTypeData.topic(slug, topicId);
    final expected = BookmarkState.bookmarked('0000-0000');

    when(repository.getTopicBookmarkState(slug)).thenAnswer((_) async => expected);

    final actual = await useCase(typeData);

    expect(actual, expected);
    verifyNever(repository.getArticleBookmarkState(any));
  });
}
