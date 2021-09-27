import 'package:injectable/injectable.dart';

const _environmentArgHost = 'host';

class AppConfig {
  final String name;
  final String apiUrl;

  /// The DSN tells where to send events so the events are associated with the correct project.
  final String sentryEventDns;

  AppConfig._(this.name, this.apiUrl, this.sentryEventDns);

  factory AppConfig.dev() {
    return AppConfig._(
      Environment.dev,
      const String.fromEnvironment(_environmentArgHost, defaultValue: 'apiUrl'),
      '',
    );
  }

  factory AppConfig.stage() {
    return AppConfig._(
      Environment.test,
      const String.fromEnvironment(_environmentArgHost, defaultValue: 'apiUrl'),
      'https://f42ea2c9bc304c3a88dd68ff3a0cd061@o785865.ingest.sentry.io/5977082',
    );
  }

  factory AppConfig.prod() {
    return AppConfig._(
      Environment.prod,
      const String.fromEnvironment(_environmentArgHost, defaultValue: 'apiUrl'),
      'https://f42ea2c9bc304c3a88dd68ff3a0cd061@o785865.ingest.sentry.io/5977082',
    );
  }
}
