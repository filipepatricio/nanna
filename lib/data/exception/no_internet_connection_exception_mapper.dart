import 'package:better_informed_mobile/data/exception/exception_mapper.dart';
import 'package:better_informed_mobile/domain/exception/no_internet_connection_exception.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class NoInternetConnectionExceptionMapper extends ExceptionMapper {
  @override
  bool isFitting(Object original) {
    if (original is OperationException) {
      final linkException = original.linkException;
      return linkException is ServerException;
    }

    return false;
  }

  @override
  Object map(Object original) => NoInternetConnectionException();
}
