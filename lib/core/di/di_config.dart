import 'package:better_informed_mobile/core/di/di_config.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final getIt = GetIt.instance;

@InjectableInit(preferRelativeImports: false)
Future<void> configureDependencies(String env) async => $initGetIt(getIt, environment: env);
