import 'package:better_informed_mobile/data/exception/common_exception_mapper.di.dart';
import 'package:better_informed_mobile/data/networking/app_version_link/app_version_link.di.dart';
import 'package:better_informed_mobile/data/networking/auth_graphql_client_factory.dart';
import 'package:better_informed_mobile/data/networking/gql_customs/custom_graphql_client.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthGraphQLClientFactory, env: mockEnvs)
class AuthGraphQLClientFactoryMock implements AuthGraphQLClientFactory {
  AuthGraphQLClientFactoryMock(
    this._appVersionLink,
    this._generalExceptionMapper,
  );

  final AppVersionLink _appVersionLink;
  final CommonExceptionMapper _generalExceptionMapper;

  @override
  GraphQLClient create() {
    return CustomGraphQlClient(
      generalExceptionMapper: _generalExceptionMapper,
      cache: GraphQLCache(),
      link: Link.from(
        [_appVersionLink],
      ),
    );
  }
}
