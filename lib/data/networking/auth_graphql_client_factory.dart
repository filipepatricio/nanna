import 'package:graphql_flutter/graphql_flutter.dart';

abstract class AuthGraphQLClientFactory {
  GraphQLClient create();
}
