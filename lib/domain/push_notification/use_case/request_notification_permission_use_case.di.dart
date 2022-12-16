import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_repository.dart';
import 'package:better_informed_mobile/domain/push_notification/push_notification_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class RequestNotificationPermissionUseCase {
  RequestNotificationPermissionUseCase(
    this._pushNotificationRepository,
    this._analyticsRepository,
  );

  final PushNotificationRepository _pushNotificationRepository;
  final AnalyticsRepository _analyticsRepository;

  Future<bool> call() async {
    final hasGivenPermission = await _pushNotificationRepository.requestPermission();

    if (hasGivenPermission) {
      _analyticsRepository.event(AnalyticsEvent.pushNotificationConsentGiven());
    }

    return hasGivenPermission;
  }
}
