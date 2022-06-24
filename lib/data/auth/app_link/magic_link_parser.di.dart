import 'package:injectable/injectable.dart';

const _pathSegment = 'magic';
const _tokenKey = 'token';

@injectable
class MagicLinkParser {
  bool isValid(Uri uri) {
    final hasMagicPathSegment = uri.pathSegments.contains(_pathSegment);
    final hasToken = uri.queryParameters[_tokenKey] != null;
    return hasMagicPathSegment && hasToken;
  }

  String parseMagicLink(Uri uri) {
    final valid = isValid(uri);

    if (valid) {
      final token = uri.queryParameters[_tokenKey];
      if (token != null) return token;
    }

    throw Exception('Provided uri is not magic link. - $uri');
  }
}
