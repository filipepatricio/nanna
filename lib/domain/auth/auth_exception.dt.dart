import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_exception.dt.freezed.dart';

@freezed
class AuthException with _$AuthException {
  factory AuthException.unknown() = _AuthExceptionUnknown;
}
