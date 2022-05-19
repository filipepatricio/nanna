import 'package:better_informed_mobile/data/exception/common_exception_mapper.di.dart';
import 'package:better_informed_mobile/data/exception/exception_mapper_facade.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

@singleton
class GraphQLResponseResolver {
  GraphQLResponseResolver(this._generalExceptionMapper);

  final CommonExceptionMapper _generalExceptionMapper;

  T? resolve<T>(
    QueryResult result,
    T Function(Map<String, dynamic> raw) mapper, {
    String? rootKey,
    ExceptionMapperFacade? customMapper,
  }) {
    final optionalException = result.exception;
    if (result.hasException && optionalException != null) {
      customMapper?.mapAndThrow(optionalException);
      _generalExceptionMapper.mapAndThrow(optionalException);
    }

    final rawData = result.data;
    if (rawData == null) return null;

    Map<String, dynamic>? data = rawData;

    if (rootKey != null) {
      data = _getInnerData(data, rootKey);
    }

    final finalData = data;
    if (finalData == null) throw Exception('Invalid data model for response.');

    return mapper(finalData);
  }

  Map<String, dynamic>? _getInnerData(Map<String, dynamic>? data, String key) {
    return data?[key] as Map<String, dynamic>?;
  }
}
