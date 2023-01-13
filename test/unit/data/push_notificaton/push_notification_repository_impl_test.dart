import 'package:better_informed_mobile/data/push_notification/api/dto/registered_push_token_dto.dt.dart';
import 'package:better_informed_mobile/data/push_notification/api/mapper/registered_push_token_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/push_notification/incoming_push/mapper/incoming_push_action_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/push_notification/incoming_push/mapper/incoming_push_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/push_notification/incoming_push/mapper/push_notification_message_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/push_notification/push_notification_messenger.di.dart';
import 'package:better_informed_mobile/data/push_notification/push_notification_repository_impl.di.dart';
import 'package:better_informed_mobile/domain/push_notification/data/registered_push_token.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../generated_mocks.mocks.dart';
import '../../../test_data.dart';

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
  late MockIncomingPushAnalyticsService analyticsService;

  setUp(() {
    firebaseMessaging = MockFirebaseMessaging();
    pushNotificationApiDataSource = MockPushNotificationApiDataSource();
    incomingPushDTOMapper = MockIncomingPushDTOMapper();
    pushNotificationMessenger = MockPushNotificationMessenger();
    registeredPushTokenDTOMapper = MockRegisteredPushTokenDTOMapper();
    notificationPreferencesDTOMapper = MockNotificationPreferencesDTOMapper();
    notificationChannelDTOMapper = MockNotificationChannelDTOMapper();
    firebaseExceptionMapper = MockFirebaseExceptionMapper();
    analyticsService = MockIncomingPushAnalyticsService();

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

  group('maps remote message to incoming push with terminated app', () {
    late PushNotificationRepositoryImpl repositoryWithOriginalMessenger;

    setUp(() {
      final remoteMessageToIncomingPushDTOMapper = RemoteMessageToIncomingPushDTOMapper();
      final incomingPushDTOMapper = IncomingPushDTOMapper(IncomingPushActionDTOMapper());
      final registeredPushTokenDTOMapper = RegisteredPushTokenDTOMapper();
      final pushNotificationMessenger = PushNotificationMessenger(
        firebaseMessaging,
        remoteMessageToIncomingPushDTOMapper,
        analyticsService,
      );

      repositoryWithOriginalMessenger = PushNotificationRepositoryImpl(
        firebaseMessaging,
        pushNotificationApiDataSource,
        incomingPushDTOMapper,
        pushNotificationMessenger,
        registeredPushTokenDTOMapper,
        notificationPreferencesDTOMapper,
        notificationChannelDTOMapper,
        firebaseExceptionMapper,
      );

      when(analyticsService.trackPressedPushNotification(any)).thenAnswer((_) {});
    });

    test('article', () async {
      when(firebaseMessaging.getInitialMessage()).thenAnswer(
        (_) async => TestData.articleRemoteMessage,
      );

      await expectLater(
        repositoryWithOriginalMessenger.pushNotificationOpenStream(),
        emitsInOrder(
          [TestData.articlePushNotification],
        ),
      );
    });

    test('topic', () async {
      when(firebaseMessaging.getInitialMessage()).thenAnswer(
        (_) async => TestData.topicRemoteMessage,
      );

      await expectLater(
        repositoryWithOriginalMessenger.pushNotificationOpenStream(),
        emitsInOrder(
          [TestData.topicPushNotification],
        ),
      );
    });

    test('topic article', () async {
      when(firebaseMessaging.getInitialMessage()).thenAnswer(
        (_) async => TestData.articleTopicRemoteMessage,
      );

      await expectLater(
        repositoryWithOriginalMessenger.pushNotificationOpenStream(),
        emitsInOrder(
          [TestData.articleTopicPushNotification],
        ),
      );
    });
  });
}
