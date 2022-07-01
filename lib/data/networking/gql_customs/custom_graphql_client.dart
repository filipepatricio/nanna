import 'package:better_informed_mobile/data/exception/common_exception_mapper.di.dart';
import 'package:better_informed_mobile/data/networking/gql_customs/custom_exception_mapper_mixin.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class CustomGraphQlClient extends GraphQLClient {
  CustomGraphQlClient({
    required this.generalExceptionMapper,
    required super.link,
    required super.cache,
  });

  final CommonExceptionMapper generalExceptionMapper;

  @override
  Future<QueryResult<TParsed>> query<TParsed>(QueryOptions<TParsed> options) async {
    final policies = defaultPolicies.query.withOverrides(options.policies);
    final result = await queryManager.query(options.copyWithPolicies(policies));
    _handleResultException(result, options);

    return result;
  }

  @override
  Future<QueryResult<TParsed>> mutate<TParsed>(MutationOptions<TParsed> options) async {
    final policies = defaultPolicies.mutate.withOverrides(options.policies);
    final result = await queryManager.mutate(options.copyWithPolicies(policies));
    _handleResultException(result, options);

    return result;
  }

  @override
  Stream<QueryResult<TParsed>> subscribe<TParsed>(SubscriptionOptions<TParsed> options) {
    final policies = defaultPolicies.subscribe.withOverrides(options.policies);
    final stream = queryManager.subscribe(options.copyWithPolicies(policies)).asBroadcastStream();

    return stream.map((event) {
      if (event.hasException) {
        _handleResultException(event, options);
      }

      return event;
    });
  }

  void _handleResultException(QueryResult<dynamic> result, dynamic options) {
    final optionalException = result.exception;
    if (result.hasException && optionalException != null) {
      if (options is CustomExceptionMapperMixin) {
        final optionsWithCustomMapper = options;
        optionsWithCustomMapper.customMapper.mapAndThrow(optionalException);
      }
      generalExceptionMapper.mapAndThrow(optionalException);
    }
  }
}
