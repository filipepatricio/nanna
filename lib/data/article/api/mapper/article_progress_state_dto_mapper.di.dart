import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/article/data/article.dart';
import 'package:injectable/injectable.dart';

@injectable
class ArticleProgressStateDTOMapper implements Mapper<String, ArticleProgressState> {
  @override
  ArticleProgressState call(String data) {
    switch (data) {
      case 'FINISHED':
        return ArticleProgressState.finished;
      case 'IN_PROGRESS':
        return ArticleProgressState.inProgress;
      case 'UNREAD':
        return ArticleProgressState.unread;
      default:
        throw Exception('Unknown article progress state: $data');
    }
  }
}
