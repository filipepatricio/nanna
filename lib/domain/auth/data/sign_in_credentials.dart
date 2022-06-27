import 'package:better_informed_mobile/data/user/api/dto/user_meta_dto.dt.dart';

class SignInCredentials {
  SignInCredentials({required this.provider, required this.token, this.code, this.userMeta});
  final String provider;
  final String token;
  final String? code;
  final UserMetaDTO? userMeta;
}
