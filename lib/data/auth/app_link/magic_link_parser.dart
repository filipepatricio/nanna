import 'package:injectable/injectable.dart';

@injectable
class MagicLinkParser {
  bool isValid(Uri uri) {
    final hasMagicPathSegment = uri.pathSegments.contains('magic');
    return hasMagicPathSegment;
  }

  String parseMagicLink(Uri uri) {
    final valid = isValid(uri);

    if (valid) {

    }

    throw Exception('Provided uri is not magic link.');
  }
}
