import 'package:better_informed_mobile/data/article/database/entity/article_progress_state_entity.hv.dart';
import 'package:better_informed_mobile/data/bidirectional_mapper.dart';
import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:injectable/injectable.dart';

const _map = {
  ArticleProgressState.unread: 'unread',
  ArticleProgressState.inProgress: 'inProgress',
  ArticleProgressState.finished: 'finished',
};

@injectable
class ArticleProgressStateEntityMapper extends BidirectionalMapper<ArticleProgressStateEntity, ArticleProgressState> {
  @override
  ArticleProgressStateEntity from(ArticleProgressState data) {
    return ArticleProgressStateEntity(name: _map[data]!);
  }

  @override
  ArticleProgressState to(ArticleProgressStateEntity data) {
    return _map.entries.firstWhere((element) => element.value == data.name).key;
  }
}
