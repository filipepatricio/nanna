import 'package:better_informed_mobile/data/push_notification/api/dto/registered_push_token_dto.dt.dart';
import 'package:better_informed_mobile/data/push_notification/push_notification_repository_impl.di.dart';
import 'package:better_informed_mobile/domain/push_notification/data/registered_push_token.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../generated_mocks.mocks.dart';

void main() {
  late PushNotificationRepositoryImpl repository;

  late MockFirebaseMessaging firebaseMessaging;
  late MockPushNotificationApiDataSource pushNotificationApiDataSource;
  late MockIncomingPushDTOMapper incomingPushDTOMapper;
  late MockPushNotificationMessenger pushNotificationMessenger;
  late MockRegisteredPushTokenDTOMapper registeredPushTokenDTOMapper;
  late MockNotificationPreferencesDTOMapper notificationPreferencesDTOMapper;
  late MockNotificationChannelDTOMapper notificationChannelDTOMapper;
  late MockFirebaseExceptionMapper firebaseExceptionMapper;

  setUp(() {
    firebaseMessaging = MockFirebaseMessaging();
    pushNotificationApiDataSource = MockPushNotificationApiDataSource();
    incomingPushDTOMapper = MockIncomingPushDTOMapper();
    pushNotificationMessenger = MockPushNotificationMessenger();
    registeredPushTokenDTOMapper = MockRegisteredPushTokenDTOMapper();
    notificationPreferencesDTOMapper = MockNotificationPreferencesDTOMapper();
    notificationChannelDTOMapper = MockNotificationChannelDTOMapper();
    firebaseExceptionMapper = MockFirebaseExceptionMapper();

    repository = PushNotificationRepositoryImpl(
      firebaseMessaging,
      pushNotificationApiDataSource,
      incomingPushDTOMapper,
      pushNotificationMessenger,
      registeredPushTokenDTOMapper,
      notificationPreferencesDTOMapper,
      notificationChannelDTOMapper,
      firebaseExceptionMapper,
    );
  });

  group('registerToken', () {
    test('throws Exception when returned token is null', () {
      when(firebaseMessaging.getToken()).thenAnswer((_) async => null);

      expect(repository.registerToken(), throwsException);
    });

    test('returns RegisteredPushToken when returned token is not null', () async {
      when(firebaseMessaging.getToken()).thenAnswer((_) async => 'token');
      when(pushNotificationApiDataSource.registerToken(any)).thenAnswer(
        (_) async => RegisteredPushTokenDTO('token', ''),
      );
      when(registeredPushTokenDTOMapper(any)).thenAnswer(
        (_) => RegisteredPushToken(
          token: 'token',
          updatedAt: DateTime.now(),
        ),
      );

      final result = await repository.registerToken();

      expect(result, isA<RegisteredPushToken>());
    });

    test('throws mapped FirebaseException by firebaseExceptionMapper', () async {
      final firebaseException = FirebaseException(plugin: 'plugin');
      final expected = Exception();

      when(firebaseMessaging.getToken()).thenAnswer((realInvocation) async => throw firebaseException);
      when(firebaseExceptionMapper.mapAndThrow(firebaseException)).thenAnswer((_) => throw expected);

      expect(repository.registerToken(), throwsA(expected));
    });
  });
}
