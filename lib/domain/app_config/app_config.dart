import 'package:injectable/injectable.dart';

const _environmentArgHost = 'host';

class AppConfig {
  final String name;
  final String apiUrl;

  AppConfig._(this.name, this.apiUrl);

  factory AppConfig.dev() {
    return AppConfig._(
      Environment.dev,
      const String.fromEnvironment(_environmentArgHost, defaultValue: 'apiUrl'),
    );
  }

  factory AppConfig.stage() {
    return AppConfig._(
      Environment.test,
      const String.fromEnvironment(_environmentArgHost, defaultValue: 'apiUrl'),
    );
  }

  factory AppConfig.prod() {
    return AppConfig._(
      Environment.prod,
      const String.fromEnvironment(_environmentArgHost, defaultValue: 'apiUrl'),
    );
  }
}
