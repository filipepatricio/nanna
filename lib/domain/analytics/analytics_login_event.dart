import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytics_login_event.freezed.dart';

@freezed
class AnalyticsLoginEvent with _$AnalyticsLoginEvent {
  factory AnalyticsLoginEvent._(String userId, String method) = _AnalyticsLoginEvent;

  factory AnalyticsLoginEvent.apple(String userId) => AnalyticsLoginEvent._(userId, 'apple');

  factory AnalyticsLoginEvent.google(String userId) => AnalyticsLoginEvent._(userId, 'google');

  factory AnalyticsLoginEvent.magicLink(String userId) => AnalyticsLoginEvent._(userId, 'magic_link');
}
