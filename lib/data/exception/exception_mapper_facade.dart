import 'package:better_informed_mobile/data/exception/exception_mapper.dart';

abstract class ExceptionMapperFacade {
  ExceptionMapperFacade(this._mappers);

  final List<ExceptionMapper> _mappers;

  void mapAndThrow(Object original) {
    for (final mapper in _mappers) {
      final mapped = mapper.mapIfFits(original);
      if (mapped != original) throw mapped;
    }
    throw original;
  }
}
