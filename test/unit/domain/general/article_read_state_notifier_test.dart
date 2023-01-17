import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:better_informed_mobile/domain/general/article_read_state_notifier.di.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../test_data.dart';

void main() {
  late ArticleReadStateNotifier notifier;

  setUp(() {
    notifier = ArticleReadStateNotifier();
  });

  test('should emit new state when article is updated', () {
    final article = TestData.article;

    expectLater(
      notifier.stream,
      emits(article),
    );

    notifier.notify(article);
  });

  test('should reemit last article value on subscription', () {
    final article = TestData.article.copyWith(progressState: ArticleProgressState.unread);
    final updatedArticle = article.copyWith(progressState: ArticleProgressState.finished);

    notifier.notify(article);
    notifier.notify(updatedArticle);

    expectLater(notifier.stream, emits(updatedArticle));
  });
}
