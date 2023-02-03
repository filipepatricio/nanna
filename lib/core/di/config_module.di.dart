import 'package:better_informed_mobile/data/util/sentry_reporting_tree.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';

@module
abstract class ConfigModule {
  @dev
  @singleton
  AppConfig get devEnv => AppConfig.dev;

  @test
  @singleton
  AppConfig get stageEnv => AppConfig.stage;

  @prod
  @singleton
  AppConfig get prodEnv => AppConfig.prod;

  @Environment(integrationStageTestName)
  @singleton
  AppConfig get integrationStageEnv => AppConfig.stage;

  @Environment(integrationProdTestName)
  @singleton
  AppConfig get integrationProdEnv => AppConfig.prod;

  @Environment(mockName)
  @singleton
  AppConfig get mockEnv => AppConfig.mock;

  @dev
  @singleton
  LogTree get devLogTree => DebugTree(useColors: true);

  @prod
  @Singleton(as: LogTree)
  SentryReportingTree get prodLogTree;

  @test
  @Singleton(as: LogTree)
  SentryReportingTree get stagingLogTree;

  @Environment(integrationProdTestName)
  @singleton
  LogTree get integrationTestLogTree => DebugTree(useColors: true);

  @Environment(mockName)
  @singleton
  LogTree get mockLogTree => DebugTree(useColors: true);
}
