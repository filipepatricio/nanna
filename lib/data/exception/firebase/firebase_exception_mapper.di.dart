import 'package:better_informed_mobile/data/exception/exception_mapper_facade.dart';
import 'package:better_informed_mobile/data/exception/firebase/firebase_authentication_exception_mapper.dart';
import 'package:better_informed_mobile/data/exception/firebase/firebase_network_exception_mapper.di.dart';
import 'package:better_informed_mobile/data/exception/firebase/firebase_unknown_exception_mapper.di.dart';
import 'package:injectable/injectable.dart';

@injectable
class FirebaseExceptionMapper extends ExceptionMapperFacade {
  FirebaseExceptionMapper()
      : super(
          [
            FirebaseAuthenticationExceptionMapper(),
            FirebaseNetworkExceptionMapper(),
            FirebaseUnknownExceptionMapper(),
          ],
        );
}
