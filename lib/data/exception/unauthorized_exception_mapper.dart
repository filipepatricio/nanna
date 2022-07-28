import 'package:better_informed_mobile/data/exception/exception_mapper.dart';
import 'package:better_informed_mobile/data/exception/graph_ql_error_extension.dart';
import 'package:better_informed_mobile/domain/exception/unauthorized_exception.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class UnauthorizedExceptionMapper extends ExceptionMapper {
  @override
  bool isFitting(Object original) {
    if (original is OperationException) {
      return original.graphqlErrors.any(_isUnauthenticated);
    }

    return false;
  }

  @override
  Object map(Object original) => UnauthorizedException();

  bool _isUnauthenticated(GraphQLError error) => error.code?.contains('UNAUTHENTICATED') ?? false;
}
