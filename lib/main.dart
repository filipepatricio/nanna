import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:better_informed_mobile/core/database/hive_initializer.dart';
import 'package:better_informed_mobile/core/di/di_config.dart';
import 'package:better_informed_mobile/data/push_notification/incoming_push/mapper/incoming_push_action_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/push_notification/incoming_push/mapper/incoming_push_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/push_notification/incoming_push/mapper/push_notification_message_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/util/badge_info_data_source.di.dart';
import 'package:better_informed_mobile/data/util/badge_info_repository_impl.di.dart';
import 'package:better_informed_mobile/data/util/reporting_tree_error_filter.di.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/initialize_analytics_use_case.di.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/auth/auth_store.dart';
import 'package:better_informed_mobile/domain/auth/data/auth_token.dart';
import 'package:better_informed_mobile/domain/util/use_case/set_needs_refresh_daily_brief_use_case.di.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/informed_app.dart';
import 'package:fimber/fimber.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:phrase/phrase.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _environmentArgKey = 'env';
const shouldRefreshBriefKey = 'shouldRefreshBrief';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final remoteMessageToIncomingPushDTOMapper = RemoteMessageToIncomingPushDTOMapper();
  final incomingPushActionDTOMapper = IncomingPushActionDTOMapper();
  final incomingPushDTOMapper = IncomingPushDTOMapper(incomingPushActionDTOMapper);
  final incomingPushDTO = remoteMessageToIncomingPushDTOMapper.call(message);
  final incomingPush = incomingPushDTOMapper.call(incomingPushDTO);
  final sharedPreferences = await SharedPreferences.getInstance();
  final badgeInfoDataSource = BadgeInfoDataSource(sharedPreferences);
  final badgeRepository = BadgeInfoRepositoryImpl(badgeInfoDataSource);
  final setNeedsRefreshDailyBriefUseCase = SetNeedsRefreshDailyBriefUseCase(badgeRepository);

  final action = incomingPush.actions.first;

  await action.mapOrNull(
    briefEntriesUpdated: (args) => setNeedsRefreshDailyBriefUseCase(args.badgeCount),
    briefEntrySeenByUser: (args) => setNeedsRefreshDailyBriefUseCase(args.badgeCount),
    newBriefPublished: (args) => setNeedsRefreshDailyBriefUseCase(args.badgeCount),
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final environment = _getEnvironment();

  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await initializeHive();
  final getIt = await configureDependencies(environment);
  final appConfig = getIt.get<AppConfig>();

  final filterController = getIt<ReportingTreeErrorFilterController>();
  await SentryFlutter.init(
    (options) => options
      ..enableBreadcrumbTrackingForCurrentPlatform()
      ..beforeSend = (event, {hint}) {
        if (filterController.shouldFilterOut(event.throwable)) return null;
        return event;
      }
      ..dsn = (kDebugMode || kProfileMode) ? '' : appConfig.sentryEventDns
      ..tracesSampleRate = 0.2
      ..environment = environment,
    appRunner: () async {
      await _setupAccessToken(getIt);
      _setupFimber(getIt);
      await _setupAnalytics(getIt);

      if (appConfig.phraseConfig != null) {
        Phrase.setup(appConfig.phraseConfig!.phraseDistributionID, appConfig.phraseConfig!.phraseEnvironmentID);
      }

      final currentThemeMode = await AdaptiveTheme.getThemeMode();

      runApp(
        DefaultAssetBundle(
          bundle: SentryAssetBundle(),
          child: InformedApp(
            getIt: getIt,
            themeMode: currentThemeMode,
            mainRouter: kDebugMode ? MainRouter() : null,
          ),
        ),
      );
    },
  );
}

void _setupFimber(GetIt getIt) {
  if (kDebugMode) {
    Fimber.plantTree(DebugTree(useColors: true));
  } else {
    Fimber.plantTree(getIt());
  }
}

Future<void> _setupAnalytics(GetIt getIt) => getIt<InitializeAnalyticsUseCase>()();

String _getEnvironment() {
  const env = String.fromEnvironment(_environmentArgKey, defaultValue: Environment.dev);

  switch (env) {
    case 'dev':
      return Environment.dev;
    case 'stage':
      return Environment.test;
    case 'prod':
      return Environment.prod;
    case 'integration_stage':
      return integrationStageTestName;
    case 'integration_prod':
      return integrationProdTestName;
    default:
      throw Exception('Unknown environment type: $env');
  }
}

Future<void> _setupAccessToken(GetIt getIt) async {
  const accessToken = String.fromEnvironment('accessToken');

  if (accessToken.isEmpty) return;

  final authStore = getIt.get<AuthStore>();
  final token = AuthToken(
    accessToken: accessToken,
    refreshToken: '',
  );

  await authStore.save(token);
}
