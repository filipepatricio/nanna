import 'package:better_informed_mobile/data/push_notification/incoming_push/dto/incoming_push_dto.dt.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class IncomingPushAnalyticsService {
  final AnalyticsRepository _analyticsRepository;

  IncomingPushAnalyticsService(this._analyticsRepository);

  void trackPressedPushNotification(IncomingPushDTO push) {
    _analyticsRepository.event(AnalyticsEvent.pushNotificationTapped(push.meta));
  }
}
