import 'package:better_informed_mobile/domain/util/use_case/get_latest_available_version_use_case.dart';
import 'package:better_informed_mobile/domain/util/use_case/should_update_app_use_case.dart';
import 'package:better_informed_mobile/presentation/widget/update_app_enforcer/app_update_checker_state.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class AppUpdateCheckerCubit extends Cubit<AppUpdateCheckerState> {
  AppUpdateCheckerCubit(
    this._getLatestAvailableVersionUseCase,
    this._shouldUpdateAppUseCase,
  ) : super(AppUpdateCheckerState.idle());

  final GetLatestAvailableVersionUseCase _getLatestAvailableVersionUseCase;
  final ShouldUpdateAppUseCase _shouldUpdateAppUseCase;

  String? _latestAvailableAppVersion;

  Future<void> initialize() async => await shouldUpdate();

  Future<bool> shouldUpdate() async {
    final shouldUpdate = await _shouldUpdateAppUseCase();
    if (shouldUpdate) {
      _latestAvailableAppVersion = await _getLatestAvailableVersionUseCase();
      emit(AppUpdateCheckerState.needsUpdate(_latestAvailableAppVersion));
    }
    return shouldUpdate;
  }
}
