import 'package:better_informed_mobile/data/user/api/dto/user_dto.dt.dart';
import 'package:better_informed_mobile/data/user/api/dto/user_meta_dto.dt.dart';
import 'package:better_informed_mobile/data/user/api/user_data_source.dart';
import 'package:better_informed_mobile/data/user/api/user_gql.dart';
import 'package:better_informed_mobile/data/util/graphql_response_resolver.di.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: UserDataSource, env: liveEnvs)
class UserGraphqlDataSource implements UserDataSource {
  final GraphQLClient _client;
  final GraphQLResponseResolver _responseResolver;

  UserGraphqlDataSource(this._client, this._responseResolver);

  @override
  Future<UserDTO> getUser() async {
    final result = await _client.query(
      QueryOptions(
        document: UserGQL.queryUser(),
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    final dto = _responseResolver.resolve(
      result,
      (raw) => UserDTO.fromJson(raw),
      rootKey: 'me',
    );

    return dto ?? (throw Exception('User can not be null'));
  }

  @override
  Future<UserDTO> updateUser(UserMetaDTO userMetaDto) async {
    final result = await _client.mutate(
      MutationOptions(
        document: UserGQL.updateUser(),
        variables: {'firstName': userMetaDto.firstName, 'lastName': userMetaDto.lastName},
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    final dto = _responseResolver.resolve(
      result,
      (raw) => UserDTO.fromJson(raw),
      rootKey: 'updateUserMeta',
    );

    return dto ?? (throw Exception('User can not be null'));
  }
}
