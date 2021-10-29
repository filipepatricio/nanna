import 'package:better_informed_mobile/domain/push_notification/data/notification_channel.dart';
import 'package:better_informed_mobile/domain/push_notification/push_notification_repository.dart';
import 'package:better_informed_mobile/domain/push_notification/use_case/set_channel_push_setting_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'set_channel_push_setting_use_case_test.mocks.dart';

@GenerateMocks(
  [
    PushNotificationRepository,
  ],
)
void main() {
  late MockPushNotificationRepository pushNotificationRepository;
  late SetChannelPushSettingUseCase useCase;

  setUp(() {
    pushNotificationRepository = MockPushNotificationRepository();
    useCase = SetChannelPushSettingUseCase(pushNotificationRepository);
  });

  test('it changes only push setting with proper channel id', () async {
    final channelIn = NotificationChannel(
      id: 'abc-abc',
      name: 'Abc',
      pushEnabled: true,
      emailEnabled: false,
    );
    final channelOut = NotificationChannel(
      id: '',
      name: '',
      pushEnabled: true,
      emailEnabled: true,
    );

    when(pushNotificationRepository.setNotificationChannel(any, any, any)).thenAnswer(
      (realInvocation) async => channelOut,
    );

    final result = await useCase(channelIn, true);

    expect(result, channelOut);
    verify(pushNotificationRepository.setNotificationChannel(channelIn.id, true, null));
  });
}
