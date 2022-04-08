import 'package:better_informed_mobile/data/invite/api/invite_api_data_source.dart';
import 'package:better_informed_mobile/data/invite/api/invite_graphql.dart';
import 'package:better_informed_mobile/data/invite/dto/invite_code_dto.dt.dart';
import 'package:better_informed_mobile/data/util/graphql_response_resolver.di.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: InviteApiDataSource, env: liveEnvs)
class InviteGraphqlDataSource implements InviteApiDataSource {
  InviteGraphqlDataSource(
    this._client,
    this._graphQLResponseResolver,
  );

  final GraphQLClient _client;
  final GraphQLResponseResolver _graphQLResponseResolver;

  @override
  Future<InviteCodeDTO> getInviteCode() async {
    final result = await _client.query(
      QueryOptions(
        document: InviteGraphql.getInviteCode(),
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    final dto = _graphQLResponseResolver.resolve(
      result,
      (raw) => InviteCodeDTO.fromJson(raw),
      rootKey: 'getInviteCode',
    );

    if (dto == null) throw Exception('Invite code is null');

    return dto;
  }
}
