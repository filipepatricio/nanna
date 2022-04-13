import 'package:better_informed_mobile/core/di/di_config.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

@InjectableInit(preferRelativeImports: false)
Future<GetIt> configureDependencies(String env) async {
  final getIt = GetIt.asNewInstance();
  await $initGetIt(getIt, environment: env);
  return getIt;
}
