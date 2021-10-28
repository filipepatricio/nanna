import 'package:injectable/injectable.dart';

const _environmentArgHost = 'host';

class AppConfig {
  final String name;
  final String apiUrl;
  final String cloudinaryCloudName;
  final String sentryEventDns;
  final String? segmentWriteKey;

  AppConfig._({
    required this.name,
    required this.apiUrl,
    required this.cloudinaryCloudName,
    required this.sentryEventDns,
    this.segmentWriteKey,
  });

  factory AppConfig.dev() {
    return AppConfig._(
      name: Environment.dev,
      apiUrl: const String.fromEnvironment(_environmentArgHost, defaultValue: 'apiUrl'),
      cloudinaryCloudName: 'informed-development',
      sentryEventDns: '',
    );
  }

  factory AppConfig.stage() {
    return AppConfig._(
      name: Environment.test,
      apiUrl: const String.fromEnvironment(
        _environmentArgHost,
        defaultValue: 'https://api.staging.informed.so/graphql',
      ),
      cloudinaryCloudName: 'informed-staging',
      sentryEventDns: 'https://f42ea2c9bc304c3a88dd68ff3a0cd061@o785865.ingest.sentry.io/5977082',
      segmentWriteKey: 'jmJAkhCovDOdxwUqbDBgpFW4xWkpLUte',
    );
  }

  factory AppConfig.prod() {
    return AppConfig._(
      name: Environment.prod,
      apiUrl: const String.fromEnvironment(_environmentArgHost, defaultValue: 'apiUrl'),
      cloudinaryCloudName: '',
      sentryEventDns: 'https://f42ea2c9bc304c3a88dd68ff3a0cd061@o785865.ingest.sentry.io/5977082',
    );
  }
}
