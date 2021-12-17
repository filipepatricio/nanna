import 'package:fresh_graphql/fresh_graphql.dart';

abstract class GraphQLFreshLinkFactory {
  Future<FreshLink<OAuth2Token>> create();
}
