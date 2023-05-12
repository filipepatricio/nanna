import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_repository.dart';
import 'package:better_informed_mobile/domain/permissions/permissions_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

@injectable
class RequestNotificationPermissionUseCase {
  RequestNotificationPermissionUseCase(
    this._permissionsRepository,
    this._analyticsRepository,
  );

  final PermissionsRepository _permissionsRepository;
  final AnalyticsRepository _analyticsRepository;

  Future<bool> call() async {
    final hasGivenPermission = await _permissionsRepository.requestPermission(Permission.notification);

    if (hasGivenPermission.isGranted) {
      _analyticsRepository.event(AnalyticsEvent.pushNotificationConsentGiven());
    }

    return hasGivenPermission.isGranted;
  }
}
