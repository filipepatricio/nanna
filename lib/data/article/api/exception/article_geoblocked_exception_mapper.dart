import 'package:better_informed_mobile/data/exception/exception_mapper.dart';
import 'package:better_informed_mobile/data/exception/graph_ql_error_extension.dart';
import 'package:better_informed_mobile/domain/article/exception/article_geoblocked_exception.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class ArticleGeoblockedExceptionMapper extends ExceptionMapper {
  @override
  bool isFitting(Object original) {
    if (original is OperationException) {
      return original.graphqlErrors.any(_isGeoblockedException);
    }

    return false;
  }

  @override
  Object map(Object original) => ArticleGeoblockedException();

  bool _isGeoblockedException(GraphQLError error) => error.code == 'GEOBLOCKED';
}
