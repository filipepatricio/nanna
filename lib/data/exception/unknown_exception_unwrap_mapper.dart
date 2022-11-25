import 'package:better_informed_mobile/data/exception/exception_mapper.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class UnknownExceptionUnwrapMapper extends ExceptionMapper {
  @override
  bool isFitting(Object original) {
    if (original is OperationException) {
      final linkException = original.linkException;
      return linkException is UnknownException;
    }

    return false;
  }

  @override
  Object map(Object original) {
    return ((original as OperationException).linkException as UnknownException).originalException!;
  }
}
