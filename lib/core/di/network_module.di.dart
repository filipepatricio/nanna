import 'package:better_informed_mobile/data/networking/auth_graphql_client_factory.dart';
import 'package:better_informed_mobile/data/networking/dato_cms_gql_client_factory.di.dart';
import 'package:better_informed_mobile/data/networking/graphql_client_factory.di.dart';
import 'package:better_informed_mobile/data/networking/graphql_fresh_link_factory.dart';
import 'package:better_informed_mobile/data/networking/graphql_guest_client_factory.di.dart';
import 'package:fresh_graphql/fresh_graphql.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

const guestGQLClientName = 'guest';
const unauthorizedGQLClientName = 'unauthorized';

@module
abstract class NetworkModule {
  @preResolve
  Future<FreshLink<OAuth2Token>> createFreshLink(GraphQLFreshLinkFactory factory) => factory.create();

  @Named(unauthorizedGQLClientName)
  @lazySingleton
  GraphQLClient createUnauthorizedClient(AuthGraphQLClientFactory factory) => factory.create();

  @lazySingleton
  GraphQLClient createClient(GraphQLClientFactory factory) => factory.create();

  @Named(guestGQLClientName)
  @lazySingleton
  GraphQLClient createGuestClient(GraphQLGuestClientFactory factory) => factory.create();

  @Named(releaseNotesClientName)
  @lazySingleton
  GraphQLClient createReleaseNotesClient(DatoCMSGQLClientFactory factory) => factory.create(releaseNotesClientName);

  @Named(legalPagesClientName)
  @lazySingleton
  GraphQLClient createLegalPagesClient(DatoCMSGQLClientFactory factory) => factory.create(legalPagesClientName);
}
