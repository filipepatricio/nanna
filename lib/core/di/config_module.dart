import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';

@module
abstract class ConfigModule {
  @dev
  @singleton
  AppConfig get devEnv => AppConfig.dev();

  @test
  @singleton
  AppConfig get stateEnv => AppConfig.stage();

  @prod
  @singleton
  AppConfig get prodEnv => AppConfig.prod();

  @singleton
  LogTree get devLogTree => DebugTree(useColors: true);
}
