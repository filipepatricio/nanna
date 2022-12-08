import 'package:better_informed_mobile/data/exception/exception_mapper.dart';
import 'package:better_informed_mobile/data/exception/firebase/firebase_network_exception.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseNetworkExceptionMapper extends ExceptionMapper {
  @override
  bool isFitting(Object original) {
    if (original is FirebaseException) {
      final message = original.message;
      if (message != null) {
        return message.contains('Could not connect to the server') ||
            message.contains('The Internet connection appears to be offline') ||
            message.contains('The network connection was lost') ||
            message.contains('International roaming is currently off') ||
            message.contains('The request timed out') ||
            message.contains('A data connection is not currently allowed') ||
            message.contains('TOO_MANY_REGISTRATIONS') ||
            message.contains('SERVICE_NOT_AVAILABLE') ||
            message.contains('An SSL error has occurred and a secure connection to the server cannot be made') ||
            message.contains('A server with the specified hostname could not be found') ||
            message.contains('cannot parse response') ||
            message.contains('bad URL');
      }
    }

    return false;
  }

  @override
  Object map(Object original) => FirebaseNetworkException();
}
