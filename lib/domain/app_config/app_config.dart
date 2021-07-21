import 'package:injectable/injectable.dart';

class AppConfig {
  final String name;
  final String apiUrl;

  AppConfig._(this.name, this.apiUrl);

  factory AppConfig.dev() {
    return AppConfig._(
      Environment.dev,
      'apiUrl',
    );
  }

  factory AppConfig.stage() {
    return AppConfig._(
      Environment.test,
      'apiUrl',
    );
  }

  factory AppConfig.prod() {
    return AppConfig._(
      Environment.prod,
      'apiUrl',
    );
  }
}
