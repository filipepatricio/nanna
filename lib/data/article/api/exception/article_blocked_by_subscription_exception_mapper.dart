import 'package:better_informed_mobile/data/exception/exception_mapper.dart';
import 'package:better_informed_mobile/data/exception/graph_ql_error_extension.dart';
import 'package:better_informed_mobile/domain/article/exception/article_blocked_by_subscription_exception.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class ArticleBlockedBySubscriptionExceptionMapper extends ExceptionMapper {
  @override
  bool isFitting(Object original) {
    if (original is OperationException) {
      return original.graphqlErrors.any(_isBlockedBySubscriptionError);
    }

    return false;
  }

  @override
  Object map(Object original) => ArticleBlockedBySubscriptionException();

  bool _isBlockedBySubscriptionError(GraphQLError error) => error.code == 'BLOCKED_BY_SUBSCRIPTION';
}
