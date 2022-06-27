import 'package:better_informed_mobile/data/user/api/documents/__generated__/query_user.ast.gql.dart' as query_user;
import 'package:better_informed_mobile/data/user/api/documents/__generated__/update_preferred_categories.ast.gql.dart'
    as update_preferred_categories;
import 'package:better_informed_mobile/data/user/api/documents/__generated__/update_user.ast.gql.dart' as update_user;
import 'package:better_informed_mobile/data/user/api/dto/user_dto.dt.dart';
import 'package:better_informed_mobile/data/user/api/dto/user_meta_dto.dt.dart';
import 'package:better_informed_mobile/data/user/api/user_data_source.dart';
import 'package:better_informed_mobile/data/util/graphql_response_resolver.di.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:fimber/fimber.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: UserDataSource, env: liveEnvs)
class UserGraphqlDataSource implements UserDataSource {
  UserGraphqlDataSource(this._client, this._responseResolver);
  final GraphQLClient _client;
  final GraphQLResponseResolver _responseResolver;

  @override
  Future<UserDTO> getUser() async {
    final result = await _client.query(
      QueryOptions(
        document: query_user.document,
        operationName: query_user.queryUser.name?.value,
        fetchPolicy: FetchPolicy.networkOnly,
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
        document: update_user.document,
        operationName: update_user.updateUserMeta.name?.value,
        variables: {
          'firstName': userMetaDto.firstName,
          'lastName': userMetaDto.lastName,
        },
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

  @override
  Future<void> updatePreferredCategories(List<String> categoryIds) => _client.mutate(
        MutationOptions(
          document: update_preferred_categories.document,
          operationName: update_preferred_categories.updatePreferredCategories.name?.value,
          variables: {
            'categoryIDs': categoryIds,
          },
          onError: (error) => Fimber.e('Could not update preferred categories', ex: error),
        ),
      );
}
