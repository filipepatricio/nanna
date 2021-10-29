import 'package:better_informed_mobile/data/user/api/dto/user_dto.dart';
import 'package:better_informed_mobile/data/user/api/user_data_source.dart';
import 'package:better_informed_mobile/data/user/api/user_gql.dart';
import 'package:better_informed_mobile/data/util/graphql_response_resolver.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: UserDataSource)
class UserGraphqlDataSource implements UserDataSource {
  final GraphQLClient _client;

  UserGraphqlDataSource(this._client);

  @override
  Future<UserDTO> getUser() async {
    final result = await _client.query(
      QueryOptions(
        document: UserGQL.queryUser(),
      ),
    );

    final dto = GraphQLResponseResolver.resolve(
      result,
      (raw) => UserDTO.fromJson(raw),
      rootKey: 'me',
    );

    return dto ?? (throw Exception('User can not be null'));
  }
}