import 'package:better_informed_mobile/data/auth/api/auth_repository_impl.di.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_graphql/fresh_graphql.dart';
import 'package:mockito/mockito.dart';

import '../../../../generated_mocks.mocks.dart';

void main() {
  late MockAuthApiDataSource authApiDataSource;
  late MockGoogleCredentialDataSource googleCredentialProviderDataSource;
  late MockAppleCredentialDataSource appleCredentialDataSource;
  late MockFreshLink<OAuth2Token> freshLink;
  late MockLoginResponseDTOMapper loginDtoMapper;
  late MockLinkedinCredentialDataSource linkedinCredentialDataSource;
  late AuthRepositoryImpl repository;

  setUp(() {
    authApiDataSource = MockAuthApiDataSource();
    googleCredentialProviderDataSource = MockGoogleCredentialDataSource();
    appleCredentialDataSource = MockAppleCredentialDataSource();
    freshLink = MockFreshLink();
    loginDtoMapper = MockLoginResponseDTOMapper();
    linkedinCredentialDataSource = MockLinkedinCredentialDataSource();

    repository = AuthRepositoryImpl(
      authApiDataSource,
      googleCredentialProviderDataSource,
      appleCredentialDataSource,
      freshLink,
      loginDtoMapper,
      linkedinCredentialDataSource,
    );
  });

  group('tokenExpirationStream', () {
    test('emits on [AuthenticationStatus.unauthenticated] event', () async {
      when(freshLink.authenticationStatus)
          .thenAnswer((realInvocation) => Stream.value(AuthenticationStatus.unauthenticated));

      await expectLater(
        repository.tokenExpirationStream(),
        emitsInOrder(
          [
            null,
          ],
        ),
      );
    });

    test('does not emit on event that is different than [AuthenticationStatus.unauthenticated]', () async {
      when(freshLink.authenticationStatus)
          .thenAnswer((realInvocation) => Stream.value(AuthenticationStatus.authenticated));

      await expectLater(
        repository.tokenExpirationStream(),
        neverEmits(null),
      );
    });

    test('does not emit on same event twice', () async {
      when(freshLink.authenticationStatus).thenAnswer(
        (realInvocation) => Stream.fromIterable(
          [
            AuthenticationStatus.unauthenticated,
            AuthenticationStatus.unauthenticated,
          ],
        ),
      );

      await expectLater(
        repository.tokenExpirationStream(),
        emitsInOrder(
          [
            null,
          ],
        ),
      );
    });

    test('emits twice when status changes between [AuthenticationStatus.unauthenticated]', () async {
      when(freshLink.authenticationStatus).thenAnswer(
        (realInvocation) => Stream.fromIterable(
          [
            AuthenticationStatus.unauthenticated,
            AuthenticationStatus.authenticated,
            AuthenticationStatus.unauthenticated,
          ],
        ),
      );

      await expectLater(
        repository.tokenExpirationStream(),
        emitsInOrder(
          [
            null,
            null,
          ],
        ),
      );
    });
  });
}
