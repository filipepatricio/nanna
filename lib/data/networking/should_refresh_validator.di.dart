import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

const unauthenticatedErrorKey = 'code';
const unauthenticatedErrorValue = 'UNAUTHENTICATED';

@lazySingleton
class ShouldRefreshValidator {
  bool call(Response response) {
    return response.errors?.any((error) {
          final errorExtensions = error.extensions;

          if (errorExtensions != null) {
            final code = errorExtensions[unauthenticatedErrorKey];
            return code == unauthenticatedErrorValue;
          }

          return false;
        }) ??
        false;
  }
}
