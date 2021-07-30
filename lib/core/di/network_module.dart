import 'package:better_informed_mobile/data/networking/auth_graphql_client_factory.dart';
import 'package:better_informed_mobile/data/networking/graphql_client_factory.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

@module
abstract class NetworkModule {
  @Named('unauthorized')
  @lazySingleton
  GraphQLClient createUnauthorizedClient(AuthGraphQLClientFactory factory) => factory.create();

  @lazySingleton
  GraphQLClient createClient(GraphQLClientFactory factory) => factory.create();
}
