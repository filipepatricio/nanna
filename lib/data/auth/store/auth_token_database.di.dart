import 'dart:convert';

import 'package:better_informed_mobile/data/auth/store/auth_token_entity.dt.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

const _key = 'authTokens';

@lazySingleton
class AuthTokenDatabase {
  final FlutterSecureStorage _storage;

  AuthTokenDatabase(this._storage);

  Future<void> save(AuthTokenEntity token) async {
    final json = jsonEncode(token.toJson());
    await _storage.write(key: _key, value: json);
  }

  Future<AuthTokenEntity?> load() async {
    try {
      final json = await _storage.read(key: _key);

      if (json == null) return null;

      final jsonMap = jsonDecode(json) as Map<String, dynamic>;
      return AuthTokenEntity.fromJson(jsonMap);
    } on PlatformException catch (_) {
      await _storage.deleteAll();
      return null;
    }
  }

  Future<void> delete() async {
    await _storage.delete(key: _key);
  }
}
