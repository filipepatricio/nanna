import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_repository.dart';
import 'package:better_informed_mobile/domain/permissions/permissions_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

@injectable
class RequestPermissionsUseCase {
  RequestPermissionsUseCase(
    this._permissionsRepository,
    this._analyticsRepository,
  );

  final PermissionsRepository _permissionsRepository;
  final AnalyticsRepository _analyticsRepository;

  Future<void> call() async {
    final notificationStatus = await _permissionsRepository.getPermissionStatus(Permission.notification);

    final statuses = await _permissionsRepository.requestPermissions([
      Permission.notification,
      Permission.appTrackingTransparency,
    ]);

    final newNotificationStatus = statuses[Permission.notification];
    final hasGivenNotificationPermission =
        notificationStatus != newNotificationStatus && newNotificationStatus == PermissionStatus.granted;

    if (hasGivenNotificationPermission) {
      _analyticsRepository.event(AnalyticsEvent.pushNotificationConsentGiven());
    }
  }
}
