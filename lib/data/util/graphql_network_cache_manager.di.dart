import 'package:better_informed_mobile/domain/util/network_cache_manager.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: NetworkCacheManager)
class GraphqlNetworkCacheManager implements NetworkCacheManager {
  GraphqlNetworkCacheManager(this._client);

  final GraphQLClient _client;

  @override
  Future<void> clear() async {
    _client.cache.store.reset();
  }
}
