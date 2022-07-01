import 'package:better_informed_mobile/data/exception/exception_mapper_facade.dart';
import 'package:better_informed_mobile/data/networking/gql_customs/custom_exception_mapper_mixin.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class QueryOptionsWithCustomExceptionMapper extends QueryOptions with CustomExceptionMapperMixin {
  QueryOptionsWithCustomExceptionMapper({
    required this.exceptionMapper,
    required super.document,
    super.variables = const {},
    super.operationName,
    super.cacheRereadPolicy,
    super.fetchPolicy,
    super.optimisticResult,
  });

  final ExceptionMapperFacade exceptionMapper;

  @override
  ExceptionMapperFacade get customMapper => exceptionMapper;
}
