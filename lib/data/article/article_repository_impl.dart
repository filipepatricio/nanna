import 'package:better_informed_mobile/domain/article/article_repository.dart';
import 'package:better_informed_mobile/domain/article/data/reading_banner.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@LazySingleton(as: ArticleRepository)
class ArticleRepositoryImpl implements ArticleRepository {
  final BehaviorSubject<ReadingBanner> _broadcaster = BehaviorSubject();

  @override
  Stream<ReadingBanner> getReadingBannerStream() => _broadcaster.stream;

  @override
  Future<void> setReadingBannerState(ReadingBanner readingBanner) async => _broadcaster.add(readingBanner);
}
