import 'package:better_informed_mobile/data/push_notification/api/push_notification_api_data_source.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: PushNotificationApiDataSource)
class PushNotificationMockApiDataSource implements PushNotificationApiDataSource {
  @override
  Future<void> registerToken(String token) {
    return Future.delayed(const Duration(seconds: 1));
  }
}
