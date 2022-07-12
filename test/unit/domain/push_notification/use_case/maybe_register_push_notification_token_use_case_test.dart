import 'package:better_informed_mobile/domain/push_notification/data/registered_push_token.dart';
import 'package:better_informed_mobile/domain/push_notification/use_case/maybe_register_push_notification_token_use_case.di.dart';
import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../generated_mocks.mocks.dart';

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
      final now = DateTime(2021);
      final registeredToken = RegisteredPushToken(token: '000-000', updatedAt: now);

      when(store.load()).thenAnswer((realInvocation) async => null);
      when(repository.registerToken()).thenAnswer((realInvocation) async => registeredToken);

      await withClock(
        Clock.fixed(now),
        () => useCase(),
      );

      verify(repository.registerToken());
      verify(store.save(registeredToken));
    });

    test('when stored one is different than current one', () async {
      const storedToken = '000-000';
      const currentToken = '111-111';

      final registeredToken = RegisteredPushToken(token: currentToken, updatedAt: DateTime(2021));

      final now = DateTime(2021);
      final storedRegisteredToken = RegisteredPushToken(
        token: storedToken,
        updatedAt: now,
      );

      when(store.load()).thenAnswer((realInvocation) async => storedRegisteredToken);
      when(repository.getCurrentToken()).thenAnswer((realInvocation) async => currentToken);
      when(repository.registerToken()).thenAnswer((realInvocation) async => registeredToken);

      await withClock(
        Clock.fixed(now),
        () => useCase(),
      );

      verify(repository.registerToken());
      verify(store.save(registeredToken));
    });

    test('when stored one is older than $daysToExpire days', () async {
      final registeredToken = RegisteredPushToken(token: '000-000', updatedAt: DateTime(2021));

      const storedToken = '000-000';
      const currentToken = '000-000';

      final storedTokenDate = DateTime(2021, 01, 01);
      final currentDate = storedTokenDate.add(const Duration(days: daysToExpire));

      final storedRegisteredToken = RegisteredPushToken(
        token: storedToken,
        updatedAt: storedTokenDate,
      );

      when(store.load()).thenAnswer((realInvocation) async => storedRegisteredToken);
      when(repository.getCurrentToken()).thenAnswer((realInvocation) async => currentToken);
      when(repository.registerToken()).thenAnswer((realInvocation) async => registeredToken);

      await withClock(
        Clock.fixed(currentDate),
        () => useCase(),
      );

      verify(repository.registerToken());
      verify(store.save(registeredToken));
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
      verifyNever(store.save(any));
    });
  });
}
