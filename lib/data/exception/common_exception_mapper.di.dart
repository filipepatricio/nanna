import 'package:better_informed_mobile/data/exception/exception_mapper.dart';
import 'package:better_informed_mobile/data/exception/no_internet_connection_exception_mapper.dart';
import 'package:better_informed_mobile/data/exception/unauthorized_exception_mapper.dart';
import 'package:injectable/injectable.dart';

@singleton
class CommonExceptionMapper {
  final List<ExceptionMapper> _mappers = [
    NoInternetConnectionExceptionMapper(),
    UnauthorizedExceptionMapper(),
  ];

  Object map(Object original) {
    for (final mapper in _mappers) {
      final mapped = mapper.mapIfFits(original);
      if (mapped != original) return mapped;
    }

    return original;
  }
}
