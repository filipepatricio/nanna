import 'package:jwt_decoder/jwt_decoder.dart';

class AuthToken {
  final JWTToken accessToken;
  final JWTToken refreshToken;

  AuthToken({
    required this.accessToken,
    required this.refreshToken,
  });
}

typedef JWTToken = String;

extension Decoded on JWTToken {
  Map<String, dynamic> decoded() => JwtDecoder.tryDecode(this) ?? <String, dynamic>{};
}
