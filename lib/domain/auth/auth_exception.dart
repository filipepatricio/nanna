import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_exception.freezed.dart';

@freezed
class AuthException with _$AuthException {
  factory AuthException.noMemberAccess() = _AuthExceptionNoMemberAccess;

  factory AuthException.unknown() = _AuthExceptionUnknown;
}
