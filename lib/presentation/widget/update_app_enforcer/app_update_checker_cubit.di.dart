import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/track_activity_use_case.di.dart';
import 'package:better_informed_mobile/domain/util/use_case/get_app_version_use_case.di.dart';
import 'package:better_informed_mobile/domain/util/use_case/get_latest_available_version_use_case.di.dart';
import 'package:better_informed_mobile/domain/util/use_case/should_update_app_use_case.di.dart';
import 'package:better_informed_mobile/presentation/widget/update_app_enforcer/app_update_checker_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class AppUpdateCheckerCubit extends Cubit<AppUpdateCheckerState> {
  AppUpdateCheckerCubit(
    this._getLatestAvailableVersionUseCase,
    this._getAppVersionUseCase,
    this._shouldUpdateAppUseCase,
    this._trackActivityUseCase,
  ) : super(AppUpdateCheckerState.idle());

  final GetLatestAvailableVersionUseCase _getLatestAvailableVersionUseCase;
  final GetAppVersionUseCase _getAppVersionUseCase;
  final ShouldUpdateAppUseCase _shouldUpdateAppUseCase;
  final TrackActivityUseCase _trackActivityUseCase;

  Future<void> initialize() async => await shouldUpdate();

  String? _latestAvailableAppVersion;

  Future<bool> shouldUpdate() async {
    final shouldUpdate = await _shouldUpdateAppUseCase();
    if (shouldUpdate) {
      _latestAvailableAppVersion = await _getLatestAvailableVersionUseCase();
      emit(AppUpdateCheckerState.needsUpdate(_latestAvailableAppVersion));
    }
    return shouldUpdate;
  }

  Future<void> trackAppUpdateDialogShown() async {
    final currentAppVersion = await _getAppVersionUseCase();
    _trackActivityUseCase.trackEvent(
      AnalyticsEvent.appUpdateDialogShown(
        currentVersion: currentAppVersion,
        availableVersion: _latestAvailableAppVersion,
      ),
    );
  }
}
