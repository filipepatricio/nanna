import 'package:better_informed_mobile/data/exception/exception_mapper.dart';
import 'package:better_informed_mobile/data/exception/firebase/firebase_unknown_exception.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseUnknownExceptionMapper extends ExceptionMapper {
  @override
  bool isFitting(Object original) {
    return original is FirebaseException;
  }

  @override
  Object map(Object original) {
    final firebaseException = original as FirebaseException;
    return FirebaseUnknownException(
      firebaseException.code,
      firebaseException.message,
    );
  }
}
