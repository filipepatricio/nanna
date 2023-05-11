import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@injectable
class ShouldShowSkipButtonUseCase {
  ShouldShowSkipButtonUseCase(this._appConfig);
  final AppConfig _appConfig;

  bool call() => kDebugMode || !_appConfig.isProd || kIsTest;
}
