import 'package:better_informed_mobile/presentation/page/main/main_cubit.dart';
import 'package:better_informed_mobile/presentation/page/settings/main/settings_main_cubit.dart';
import 'package:injectable/injectable.dart';

@module
abstract class CubitModule {
  MainCubit getMainCubit() => MainCubit();
  SettingsMainCubit getSettingsMainCubit() => SettingsMainCubit();
}
