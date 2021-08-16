import 'package:better_informed_mobile/data/auth/app_link/magic_link_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late MagicLinkParser parser;

  setUp(() {
    parser = MagicLinkParser();
  });

  group('isValid', () {
    test('returns false when path segment keyword is missing', () {
      final uri = Uri.parse('http://localhost:3000/signIn?callbackUrl=&token=eyJhbGciOiJ');

      final actual = parser.isValid(uri);

      expect(actual, false);
    });

    test('returns false when token param is missing', () {
      final uri = Uri.parse('http://localhost:3000/magic?callbackUrl=');

      final actual = parser.isValid(uri);

      expect(actual, false);
    });

    test('returns true when token and segment keyword are available', () {
      final uri = Uri.parse('http://localhost:3000/magic?callbackUrl=&token=eyJhbGciOiJ');

      final actual = parser.isValid(uri);

      expect(actual, true);
    });
  });

  group('parseMagicLink', () {
    test('throws Exception when link is invalid', () {
      final uri = Uri.parse('http://localhost:3000/magic?callbackUrl=');

      expect(
        () => parser.parseMagicLink(uri),
        throwsA(
          isA<Exception>(),
        ),
      );
    });

    test('returns token from magic link', () {
      const token = 'eyJhbGciOiJ';
      final uri = Uri.parse('http://localhost:3000/magic?callbackUrl=&token=$token');

      final actual = parser.parseMagicLink(uri);

      expect(actual, token);
    });
  });
}
