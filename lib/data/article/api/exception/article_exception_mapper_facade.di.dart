import 'package:better_informed_mobile/data/article/api/exception/article_geoblocked_exception_mapper.dart';
import 'package:better_informed_mobile/data/exception/exception_mapper_facade.dart';
import 'package:injectable/injectable.dart';

@injectable
class ArticleExceptionMapperFacade extends ExceptionMapperFacade {
  ArticleExceptionMapperFacade()
      : super(
          [
            ArticleGeoblockedExceptionMapper(),
          ],
        );
}
