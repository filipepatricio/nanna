import 'package:better_informed_mobile/data/common/dto/successful_response_dto.dt.dart';
import 'package:better_informed_mobile/data/subscription/api/documents/__generated__/subscription_purchased.ast.gql.dart'
    as subscription_purchased;
import 'package:better_informed_mobile/data/subscription/api/purchase_api_data_source.dart';
import 'package:better_informed_mobile/data/util/graphql_response_resolver.di.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: PurchaseApiDataSource, env: defaultEnvs)
class PurchaseGraphqlDataSource implements PurchaseApiDataSource {
  PurchaseGraphqlDataSource(this._client, this._responseResolver);
  final GraphQLClient _client;
  final GraphQLResponseResolver _responseResolver;

  @override
  Future<SuccessfulResponseDTO> forceSubscriptionStatusSync() async {
    final result = await _client.mutate(
      MutationOptions(
        document: subscription_purchased.document,
        operationName: subscription_purchased.subscriptionPurchased.name?.value,
      ),
    );

    final dto = _responseResolver.resolve(
      result,
      (raw) => SuccessfulResponseDTO.fromJson(raw),
      rootKey: 'subscriptionPurchased',
    );

    return dto ?? SuccessfulResponseDTO(false);
  }
}
