import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_exception.dt.freezed.dart';

@Freezed(toJson: false)
class AuthException with _$AuthException {
  factory AuthException.unknown() = _AuthExceptionUnknown;

  factory AuthException.unauthorized() = _AuthExceptionUnauthorized;
}
