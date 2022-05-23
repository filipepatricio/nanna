import 'package:better_informed_mobile/data/networking/auth_graphql_client_factory.dart';
import 'package:better_informed_mobile/data/networking/graphql_client_factory.di.dart';
import 'package:better_informed_mobile/data/networking/graphql_fresh_link_factory.dart';
import 'package:better_informed_mobile/data/release_notes/api/release_notes_gql_client_factory.di.dart';
import 'package:fresh_graphql/fresh_graphql.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

@module
abstract class NetworkModule {
  @preResolve
  Future<FreshLink<OAuth2Token>> createFreshLink(GraphQLFreshLinkFactory factory) => factory.create();

  @Named('unauthorized')
  @lazySingleton
  GraphQLClient createUnauthorizedClient(AuthGraphQLClientFactory factory) => factory.create();

  @lazySingleton
  GraphQLClient createClient(GraphQLClientFactory factory) => factory.create();

  @Named('releaseNotes')
  @lazySingleton
  GraphQLClient createReleaseNotesClient(ReleaseNotesGQLClientFactory factory) => factory.create();
}
