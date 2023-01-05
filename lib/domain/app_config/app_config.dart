import 'dart:io';

import 'package:better_informed_mobile/domain/app_config/linkedin_config.dart';
import 'package:injectable/injectable.dart';

const _environmentArgHost = 'host';

const mockName = 'mock';
const integrationTestName = 'integration_test';

const liveEnvs = [Environment.dev, Environment.test, Environment.prod];

const defaultEnvs = [...liveEnvs, integrationTestName];

const integrationTestEnvs = [integrationTestName];

const mockEnvs = [mockName];

const testEnvs = [mockName, integrationTestName];

bool kIsAppleDevice = Platform.isIOS;

final kIsTest = Platform.environment.containsKey('FLUTTER_TEST');

class AppConfig {
  const AppConfig._({
    required this.name,
    required this.apiUrl,
    required this.cloudinaryCloudName,
    required this.sentryEventDns,
    required this.appId,
    required this.appleStoreId,
    required this.datoCMSKey,
    required this.linkedinConfig,
    this.segmentWriteKey,
    this.launchDarklyKey,
    this.appsFlyerKey,
    this.revenueCatKeyiOS,
    this.revenueCatKeyAndroid,
    this.revenueCatPremiumEntitlementId,
    this.appsFlyerLinkPath,
  });

  final String name;
  final String apiUrl;
  final String cloudinaryCloudName;
  final String sentryEventDns;
  final String appId;
  final String appleStoreId;
  final String datoCMSKey;
  final LinkedinConfig linkedinConfig;
  final String? segmentWriteKey;
  final String? launchDarklyKey;
  final String? appsFlyerKey;
  final String? revenueCatKeyiOS;
  final String? revenueCatKeyAndroid;
  final String? revenueCatPremiumEntitlementId;
  final String? appsFlyerLinkPath;

  static const dev = AppConfig._(
    name: Environment.dev,
    apiUrl: String.fromEnvironment(_environmentArgHost, defaultValue: 'apiUrl'),
    cloudinaryCloudName: 'informed-development',
    sentryEventDns: '',
    appId: 'so.informed.dev',
    appleStoreId: '',
    datoCMSKey: '1ecd2461c830b09d98d34b7cc9cd25',
    linkedinConfig: LinkedinConfig.dev(),
    launchDarklyKey: 'mob-348e437c-2b6b-42f5-9a74-5599f33908c0',
    appsFlyerKey: 'dev_key',
    revenueCatKeyiOS: 'appl_lmbriZAQhIhAfDEMDIcCyaRwZjD',
    revenueCatKeyAndroid: 'goog_KvJYjAuvczWsabJAOxFZeVCLRnA',
    revenueCatPremiumEntitlementId: 'premium',
  );

  static const mock = AppConfig._(
    name: mockName,
    apiUrl: String.fromEnvironment(_environmentArgHost, defaultValue: 'apiUrl'),
    cloudinaryCloudName: 'informed-development',
    sentryEventDns: '',
    appId: 'so.informed.mock',
    appleStoreId: '',
    datoCMSKey: '1ecd2461c830b09d98d34b7cc9cd25',
    linkedinConfig: LinkedinConfig.dev(),
    revenueCatPremiumEntitlementId: 'premium',
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
    datoCMSKey: '1ecd2461c830b09d98d34b7cc9cd25',
    linkedinConfig: LinkedinConfig.staging(),
    launchDarklyKey: 'mob-348e437c-2b6b-42f5-9a74-5599f33908c0',
    appsFlyerKey: 'MrhtK2n5TX5wZjYD7Goe4U',
    revenueCatKeyiOS: 'appl_lmbriZAQhIhAfDEMDIcCyaRwZjD',
    revenueCatKeyAndroid: 'goog_KvJYjAuvczWsabJAOxFZeVCLRnA',
    revenueCatPremiumEntitlementId: 'premium',
    appsFlyerLinkPath: '/tHNA',
  );

  static const prod = AppConfig._(
    name: Environment.prod,
    apiUrl: String.fromEnvironment(_environmentArgHost, defaultValue: 'https://api.informed.so/graphql'),
    cloudinaryCloudName: 'informed',
    sentryEventDns: 'https://f42ea2c9bc304c3a88dd68ff3a0cd061@o785865.ingest.sentry.io/5977082',
    segmentWriteKey: 'Jp2reNsfGRxapvFlgmDYBsRJ2LA2TLSP',
    appId: 'so.informed',
    appleStoreId: '1577915307',
    datoCMSKey: '1ecd2461c830b09d98d34b7cc9cd25',
    linkedinConfig: LinkedinConfig.prod(),
    launchDarklyKey: 'mob-15482f92-5c32-458a-a3c9-4323b6d03656',
    appsFlyerKey: 'MrhtK2n5TX5wZjYD7Goe4U',
    revenueCatKeyiOS: 'appl_vbotzvGRlvvfVSpOPubjlvxDApQ',
    revenueCatKeyAndroid: 'goog_jUdAAFYAkEzYinZAmOWysZPVOut',
    revenueCatPremiumEntitlementId: 'premium',
    appsFlyerLinkPath: '/BHtj',
  );
}
