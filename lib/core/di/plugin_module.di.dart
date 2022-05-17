import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@module
abstract class PluginModule {
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();

  FirebaseMessaging get firebaseMessaging => FirebaseMessaging.instance;
}
