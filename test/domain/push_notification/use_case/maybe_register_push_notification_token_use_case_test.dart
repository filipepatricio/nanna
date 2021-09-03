import 'package:better_informed_mobile/domain/push_notification/data/registered_push_token.dart';
import 'package:better_informed_mobile/domain/push_notification/push_notification_repository.dart';
import 'package:better_informed_mobile/domain/push_notification/push_notification_store.dart';
import 'package:better_informed_mobile/domain/push_notification/use_case/maybe_register_push_notification_token_use_case.dart';
import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'maybe_register_push_notification_token_use_case_test.mocks.dart';

@GenerateMocks(
  [
    PushNotificationStore,
    PushNotificationRepository,
  ],
)
void main() {
  late MaybeRegisterPushNotificationTokenUseCase useCase;
  late MockPushNotificationStore store;
  late MockPushNotificationRepository repository;

  setUp(() {
    store = MockPushNotificationStore();
    repository = MockPushNotificationRepository();
    useCase = MaybeRegisterPushNotificationTokenUseCase(store, repository);
  });

  group('registers new token', () {
    test('when store is empty', () async {
      when(store.load()).thenAnswer((realInvocation) async => null);

      await useCase();

      verify(repository.registerToken());
    });

    test('when stored one is different than current one', () async {
      const storedToken = '000-000';
      const currentToken = '111-111';
      final registeredToken = RegisteredPushToken(
        token: storedToken,
        updatedAt: DateTime(2021),
      );

      when(store.load()).thenAnswer((realInvocation) async => registeredToken);
      when(repository.getCurrentToken()).thenAnswer((realInvocation) async => currentToken);

      await useCase();

      verify(repository.registerToken());
    });

    test('when stored one is older than $daysToExpire days', () async {
      const storedToken = '000-000';
      const currentToken = '000-000';

      final storedTokenDate = DateTime(2021, 01, 01);
      final currentDate = storedTokenDate.add(const Duration(days: daysToExpire));

      final registeredToken = RegisteredPushToken(
        token: storedToken,
        updatedAt: storedTokenDate,
      );

      when(store.load()).thenAnswer((realInvocation) async => registeredToken);
      when(repository.getCurrentToken()).thenAnswer((realInvocation) async => currentToken);

      await withClock(
        Clock.fixed(currentDate),
        () => useCase(),
      );

      verify(repository.registerToken());
    });
  });

  group('does not register new token', () {
    test('when store contains current token that is not expired', () async {
      const storedToken = '000-000';
      const currentToken = '000-000';

      final storedTokenDate = DateTime(2021, 01, 01);
      final currentDate = storedTokenDate.add(const Duration(days: daysToExpire, seconds: -1));

      final registeredToken = RegisteredPushToken(
        token: storedToken,
        updatedAt: storedTokenDate,
      );

      when(store.load()).thenAnswer((realInvocation) async => registeredToken);
      when(repository.getCurrentToken()).thenAnswer((realInvocation) async => currentToken);

      await withClock(
        Clock.fixed(currentDate),
        () => useCase(),
      );

      verifyNever(repository.registerToken());
    });
  });
}
