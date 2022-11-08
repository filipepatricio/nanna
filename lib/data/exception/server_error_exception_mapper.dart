import 'package:better_informed_mobile/data/exception/exception_mapper.dart';
import 'package:better_informed_mobile/domain/exception/server_error_exception.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class ServerErrorExceptionMapper extends ExceptionMapper {
  @override
  bool isFitting(Object original) {
    if (original is OperationException) {
      final linkException = original.linkException;
      if (linkException is ResponseFormatException) {
        final originalException = linkException.originalException;
        return originalException is FormatException && originalException.message.contains('<html>');
      }
    }

    return false;
  }

  @override
  Object map(Object original) => ServerErrorException(original);
}
