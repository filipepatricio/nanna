import 'package:better_informed_mobile/data/networking/app_version_link/app_version_link.dart';
import 'package:better_informed_mobile/data/networking/auth_graphql_client_factory.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthGraphQLClientFactory, env: mockEnvs)
class AuthGraphQLClientFactoryMock implements AuthGraphQLClientFactory {
  final AppVersionLink _appVersionLink;

  AuthGraphQLClientFactoryMock(this._appVersionLink);

  @override
  GraphQLClient create() {
    return GraphQLClient(
      cache: GraphQLCache(),
      link: Link.from(
        [_appVersionLink],
      ),
    );
  }
}
