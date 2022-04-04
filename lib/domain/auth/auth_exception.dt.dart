import 'package:better_informed_mobile/domain/auth/data/sign_in_credentials.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_exception.dt.freezed.dart';

@freezed
class AuthException with _$AuthException {
  factory AuthException.noMemberAccess(SignInCredentials credentials) = _AuthExceptionNoMemberAccess;

  factory AuthException.unknown() = _AuthExceptionUnknown;
}
