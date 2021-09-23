import 'dart:math';

import 'package:better_informed_mobile/domain/daily_brief/use_case/get_current_brief_use_case.dart';
import 'package:better_informed_mobile/domain/my_reads/data/my_reads_content.dart';
import 'package:better_informed_mobile/domain/my_reads/data/my_reads_item.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetMyReadsContentUseCase {
  // TODO temporary
  final GetCurrentBriefUseCase _getCurrentBriefUseCase;

  GetMyReadsContentUseCase(this._getCurrentBriefUseCase);

  Future<MyReadsContent> call() async {
    await Future.delayed(const Duration(seconds: 1));
    final brief = await _getCurrentBriefUseCase();

    final random = Random();
    final itemsCount = random.nextInt(brief.topics.length);

    final items = brief.topics.take(itemsCount).map(
      (topic) {
        final articlesCount = topic.readingList.articles.length;
        return MyReadsItem(
          topic: topic,
          articlesCount: articlesCount,
          finishedArticlesCount: random.nextInt(articlesCount - 1) + 1,
        );
      },
    ).toList();

    return MyReadsContent(
      itemsCount: itemsCount,
      items: items,
    );
  }
}
