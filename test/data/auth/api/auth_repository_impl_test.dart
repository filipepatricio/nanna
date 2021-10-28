import 'package:better_informed_mobile/data/auth/api/auth_api_data_source.dart';
import 'package:better_informed_mobile/data/auth/api/auth_repository_impl.dart';
import 'package:better_informed_mobile/data/auth/api/mapper/auth_token_dto_mapper.dart';
import 'package:better_informed_mobile/data/auth/api/mapper/login_response_dto_mapper.dart';
import 'package:better_informed_mobile/data/auth/api/provider/oauth_sign_in_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_graphql/fresh_graphql.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_repository_impl_test.mocks.dart';

@GenerateMocks(
  [
    AuthApiDataSource,
    OAuthSignInDataSource,
    AuthTokenDTOMapper,
    FreshLink,
    LoginResponseDTOMapper,
  ],
)
void main() {
  late MockAuthApiDataSource authApiDataSource;
  late MockOAuthSignInDataSource oAuthSignInDataSource;
  late MockFreshLink<OAuth2Token> freshLink;
  late MockLoginResponseDTOMapper loginDtoMapper;
  late AuthRepositoryImpl repository;

  setUp(() {
    authApiDataSource = MockAuthApiDataSource();
    oAuthSignInDataSource = MockOAuthSignInDataSource();
    freshLink = MockFreshLink();
    loginDtoMapper = MockLoginResponseDTOMapper();

    repository = AuthRepositoryImpl(
      authApiDataSource,
      oAuthSignInDataSource,
      freshLink,
      loginDtoMapper,
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
