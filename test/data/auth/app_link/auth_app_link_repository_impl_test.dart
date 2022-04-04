import 'package:better_informed_mobile/data/app_link/app_link_data_source.dart';
import 'package:better_informed_mobile/data/auth/app_link/auth_app_link_repository_impl.di.dart';
import 'package:better_informed_mobile/data/auth/app_link/magic_link_parser.di.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_app_link_repository_impl_test.mocks.dart';

@GenerateMocks(
  [
    AppLinkDataSource,
    MagicLinkParser,
  ],
)
void main() {
  late MockAppLinkDataSource appLinkDataSource;
  late MockMagicLinkParser magicLinkParser;
  late AuthAppLinkRepositoryImpl repository;

  setUp(() {
    appLinkDataSource = MockAppLinkDataSource();
    magicLinkParser = MockMagicLinkParser();
    repository = AuthAppLinkRepositoryImpl(appLinkDataSource, magicLinkParser);
  });

  group('subscribeForMagicLinkToken', () {
    test('emits initial link only once', () async {
      final initialLink = Uri.parse('http://localhost:3000/magic');
      const token = 'AbCdEf123';

      when(appLinkDataSource.getInitialAction()).thenAnswer((realInvocation) async => initialLink);
      when(appLinkDataSource.listenForIncomingActions()).thenAnswer((realInvocation) => const Stream.empty());
      when(magicLinkParser.isValid(any)).thenAnswer((realInvocation) => true);
      when(magicLinkParser.parseMagicLink(any)).thenAnswer((realInvocation) => token);

      // First invocation should consider initialLink
      await expectLater(
        repository.subscribeForMagicLinkToken(),
        emitsInOrder(
          [token],
        ),
      );

      // Second invocation should not consider initial link
      await expectLater(
        repository.subscribeForMagicLinkToken(),
        neverEmits(token),
      );
    });

    test('emits in order [initial link, link from stream, link from stream]', () async {
      final initialLink = Uri.parse('http://localhost:3000/magic');
      final linkFromStream = Uri.parse('http://localhost:3000/magic?other');
      const initialLinkToken = 'AbCdEf123';
      const linkFromStreamToken = 'dEfGh987';

      when(appLinkDataSource.getInitialAction()).thenAnswer((realInvocation) async => initialLink);
      when(appLinkDataSource.listenForIncomingActions())
          .thenAnswer((realInvocation) => Stream.fromIterable([linkFromStream, linkFromStream]));
      when(magicLinkParser.isValid(any)).thenAnswer((realInvocation) => true);
      when(magicLinkParser.parseMagicLink(any)).thenAnswer((realInvocation) {
        final link = realInvocation.positionalArguments[0] as Uri;
        if (link == initialLink) {
          return initialLinkToken;
        } else if (link == linkFromStream) {
          return linkFromStreamToken;
        } else {
          throw Exception();
        }
      });

      await expectLater(
        repository.subscribeForMagicLinkToken(),
        emitsInOrder(
          [initialLinkToken, linkFromStreamToken, linkFromStreamToken],
        ),
      );
    });

    test('emits tokens only for valid magic links', () async {
      final correctLink = Uri.parse('http://localhost:3000/magic');
      final wrongLink = Uri.parse('http://localhost:3000/notMagic');
      const token = 'AbCdEf123';

      when(appLinkDataSource.getInitialAction()).thenAnswer((realInvocation) async => null);
      when(appLinkDataSource.listenForIncomingActions())
          .thenAnswer((realInvocation) => Stream.fromIterable([wrongLink, correctLink, correctLink]));
      when(magicLinkParser.isValid(any)).thenAnswer((realInvocation) {
        final link = realInvocation.positionalArguments[0] as Uri;
        if (link == correctLink) return true;
        return false;
      });
      when(magicLinkParser.parseMagicLink(any)).thenAnswer((realInvocation) => token);

      await expectLater(
        repository.subscribeForMagicLinkToken(),
        emitsInOrder(
          [token, token],
        ),
      );
    });
  });
}
