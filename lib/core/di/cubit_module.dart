import 'package:better_informed_mobile/presentation/page/dashboard/dashboard_cubit.dart';
import 'package:injectable/injectable.dart';

@module
abstract class CubitModule {
  DashboardCubit getDashboardCubit() => DashboardCubit();
}
