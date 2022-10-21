import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_channel.dt.freezed.dart';

@Freezed(toJson: false)
class NotificationChannel with _$NotificationChannel {
  factory NotificationChannel({
    required String id,
    required String name,
    required String description,
    required bool pushEnabled,
    required bool emailEnabled,
  }) = _NotificationChannel;
}
