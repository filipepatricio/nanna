import 'package:better_informed_mobile/data/exception/exception_mapper.dart';
import 'package:better_informed_mobile/data/exception/firebase/firebase_authentication_exception.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseAuthenticationExceptionMapper extends ExceptionMapper {
  @override
  bool isFitting(Object original) {
    if (original is FirebaseException) {
      final message = original.message;
      return message != null && message.contains('AUTHENTICATION_FAILED');
    }

    return false;
  }

  @override
  Object map(Object original) => FirebaseAuthenticationException();
}
