import 'dart:io';

import 'package:injectable/injectable.dart';

const _environmentArgHost = 'host';

const mockName = 'mock';

const liveEnvs = [Environment.dev, Environment.test, Environment.prod];

const mockEnvs = [mockName];

bool kIsAppleDevice = Platform.isIOS;

final kIsTest = Platform.environment.containsKey('FLUTTER_TEST');

class AppConfig {
  final String name;
  final String apiUrl;
  final String cloudinaryCloudName;
  final String sentryEventDns;
  final String appId;
  final String appleStoreId;
  final String? segmentWriteKey;
  final String? launchDarklyKey;
  final String? appsFlyerKey;

  const AppConfig._({
    required this.name,
    required this.apiUrl,
    required this.cloudinaryCloudName,
    required this.sentryEventDns,
    required this.appId,
    required this.appleStoreId,
    this.segmentWriteKey,
    this.launchDarklyKey,
    this.appsFlyerKey,
  });

  static const dev = AppConfig._(
    name: Environment.dev,
    apiUrl: String.fromEnvironment(_environmentArgHost, defaultValue: 'apiUrl'),
    cloudinaryCloudName: 'informed-development',
    sentryEventDns: '',
    appId: 'so.informed.dev',
    appleStoreId: '',
    launchDarklyKey: 'mob-348e437c-2b6b-42f5-9a74-5599f33908c0',
  );

  static const mock = AppConfig._(
    name: mockName,
    apiUrl: String.fromEnvironment(_environmentArgHost, defaultValue: 'apiUrl'),
    cloudinaryCloudName: 'informed-development',
    sentryEventDns: '',
    appId: 'so.informed.mock',
    appleStoreId: '',
  );

  static const stage = AppConfig._(
    name: Environment.test,
    apiUrl: String.fromEnvironment(
      _environmentArgHost,
      defaultValue: 'https://api.staging.informed.so/graphql',
    ),
    cloudinaryCloudName: 'informed-staging',
    sentryEventDns: 'https://f42ea2c9bc304c3a88dd68ff3a0cd061@o785865.ingest.sentry.io/5977082',
    segmentWriteKey: 'jmJAkhCovDOdxwUqbDBgpFW4xWkpLUte',
    appId: 'so.informed.staging',
    appleStoreId: '1587844260',
    launchDarklyKey: 'mob-348e437c-2b6b-42f5-9a74-5599f33908c0',
    appsFlyerKey: 'MrhtK2n5TX5wZjYD7Goe4U',
  );

  static const prod = AppConfig._(
    name: Environment.prod,
    apiUrl: String.fromEnvironment(_environmentArgHost, defaultValue: 'https://api.informed.so/graphql'),
    cloudinaryCloudName: 'informed',
    sentryEventDns: 'https://f42ea2c9bc304c3a88dd68ff3a0cd061@o785865.ingest.sentry.io/5977082',
    segmentWriteKey: 'Jp2reNsfGRxapvFlgmDYBsRJ2LA2TLSP',
    appId: 'so.informed',
    appleStoreId: '1577915307',
    launchDarklyKey: 'mob-15482f92-5c32-458a-a3c9-4323b6d03656',
    appsFlyerKey: 'MrhtK2n5TX5wZjYD7Goe4U',
  );
}
