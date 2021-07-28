import 'package:better_informed_mobile/presentation/page/dashboard/dashboard_state.dart';
import 'package:bloc/bloc.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(const DashboardState.init());
}
