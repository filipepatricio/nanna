import 'dart:io';

import 'package:better_informed_mobile/domain/app_config/datocms_config.dart';
import 'package:better_informed_mobile/domain/app_config/linkedin_config.dart';
import 'package:better_informed_mobile/domain/app_config/phrase_config.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

const _environmentArgHost = 'host';

const mockName = 'mock';
const integrationProdTestName = 'integration_prod_test';
const integrationStageTestName = 'integration_stage_test';

const liveEnvs = [Environment.dev, Environment.test, Environment.prod];

const integrationTestEnvs = [integrationProdTestName, integrationStageTestName];

const defaultEnvs = [...liveEnvs, ...integrationTestEnvs];

const mockEnvs = [mockName];

const testEnvs = [...mockEnvs, ...integrationTestEnvs];

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
    required this.datoCMSConfig,
    required this.linkedinConfig,
    required this.facebookAppIdiOS,
    required this.facebookAppIdAndroid,
    this.segmentWriteKey,
    this.launchDarklyKey,
    this.appsFlyerKey,
    this.revenueCatKeyiOS,
    this.revenueCatKeyAndroid,
    this.revenueCatPremiumEntitlementId,
    this.appsFlyerLinkPath = const [],
    this.phraseConfig,
  });

  final String name;
  final String apiUrl;
  final String cloudinaryCloudName;
  final String sentryEventDns;
  final String appId;
  final String appleStoreId;
  final DatoCMSConfig datoCMSConfig;
  final LinkedinConfig linkedinConfig;
  final String facebookAppIdiOS;
  final String facebookAppIdAndroid;
  final String? segmentWriteKey;
  final String? launchDarklyKey;
  final String? appsFlyerKey;
  final String? revenueCatKeyiOS;
  final String? revenueCatKeyAndroid;
  final String? revenueCatPremiumEntitlementId;
  final List<String> appsFlyerLinkPath;
  final PhraseConfig? phraseConfig;

  bool get isProd => name == Environment.prod;

  static const dev = AppConfig._(
    name: Environment.dev,
    apiUrl: String.fromEnvironment(_environmentArgHost, defaultValue: 'apiUrl'),
    cloudinaryCloudName: 'informed-development',
    sentryEventDns: '',
    appId: 'so.informed.dev',
    appleStoreId: '',
    datoCMSConfig: DatoCMSConfig.global(),
    linkedinConfig: LinkedinConfig.dev(),
    facebookAppIdiOS: '',
    facebookAppIdAndroid: '',
    launchDarklyKey: 'mob-348e437c-2b6b-42f5-9a74-5599f33908c0',
    appsFlyerKey: 'dev_key',
    revenueCatKeyiOS: 'appl_lmbriZAQhIhAfDEMDIcCyaRwZjD',
    revenueCatKeyAndroid: 'goog_KvJYjAuvczWsabJAOxFZeVCLRnA',
    revenueCatPremiumEntitlementId: 'premium',
    phraseConfig: PhraseConfig.dev(),
  );

  static const mock = AppConfig._(
    name: mockName,
    apiUrl: String.fromEnvironment(_environmentArgHost, defaultValue: 'apiUrl'),
    cloudinaryCloudName: 'informed-development',
    sentryEventDns: '',
    appId: 'so.informed.mock',
    appleStoreId: '',
    datoCMSConfig: DatoCMSConfig.global(),
    linkedinConfig: LinkedinConfig.dev(),
    facebookAppIdiOS: '',
    facebookAppIdAndroid: '',
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
    datoCMSConfig: DatoCMSConfig.global(),
    linkedinConfig: LinkedinConfig.staging(),
    facebookAppIdiOS: '5582742288476971',
    facebookAppIdAndroid: '1152910382298060',
    launchDarklyKey: 'mob-348e437c-2b6b-42f5-9a74-5599f33908c0',
    appsFlyerKey: 'MrhtK2n5TX5wZjYD7Goe4U',
    revenueCatKeyiOS: 'appl_lmbriZAQhIhAfDEMDIcCyaRwZjD',
    revenueCatKeyAndroid: 'goog_KvJYjAuvczWsabJAOxFZeVCLRnA',
    revenueCatPremiumEntitlementId: 'premium',
    appsFlyerLinkPath: ['/tHNA'],
    phraseConfig: kDebugMode ? PhraseConfig.dev() : PhraseConfig.staging(),
  );

  static const prod = AppConfig._(
    name: Environment.prod,
    apiUrl: String.fromEnvironment(_environmentArgHost, defaultValue: 'https://api.informed.so/graphql'),
    cloudinaryCloudName: 'informed',
    sentryEventDns: 'https://f42ea2c9bc304c3a88dd68ff3a0cd061@o785865.ingest.sentry.io/5977082',
    segmentWriteKey: 'Jp2reNsfGRxapvFlgmDYBsRJ2LA2TLSP',
    appId: 'so.informed',
    appleStoreId: '1577915307',
    datoCMSConfig: DatoCMSConfig.global(),
    linkedinConfig: LinkedinConfig.prod(),
    facebookAppIdiOS: '525120512609664',
    facebookAppIdAndroid: '345458011020663',
    launchDarklyKey: 'mob-15482f92-5c32-458a-a3c9-4323b6d03656',
    appsFlyerKey: 'MrhtK2n5TX5wZjYD7Goe4U',
    revenueCatKeyiOS: 'appl_vbotzvGRlvvfVSpOPubjlvxDApQ',
    revenueCatKeyAndroid: 'goog_jUdAAFYAkEzYinZAmOWysZPVOut',
    revenueCatPremiumEntitlementId: 'premium',
    appsFlyerLinkPath: ['/BHtj', '/FtMU'],
    phraseConfig: PhraseConfig.prod(),
  );
}
