import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_channel.dt.freezed.dart';

@freezed
class NotificationChannel with _$NotificationChannel {
  factory NotificationChannel({
    required String id,
    required String name,
    required bool pushEnabled,
    required bool emailEnabled,
  }) = _NotificationChannel;
}
