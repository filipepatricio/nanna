import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_state.dt.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_type_data.dt.dart';
import 'package:better_informed_mobile/domain/bookmark/use_case/get_bookmark_state_use_case.di.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../generated_mocks.mocks.dart';

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
    const type = ArticleType.premium;
    const typeData = BookmarkTypeData.article(slug, articleId, type);
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
