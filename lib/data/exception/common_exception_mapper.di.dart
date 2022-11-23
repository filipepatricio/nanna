import 'package:better_informed_mobile/data/exception/exception_mapper_facade.dart';
import 'package:better_informed_mobile/data/exception/no_internet_connection_exception_mapper.dart';
import 'package:better_informed_mobile/data/exception/server_error_exception_mapper.dart';
import 'package:better_informed_mobile/data/exception/unauthorized_exception_mapper.dart';
import 'package:better_informed_mobile/data/exception/unknown_exception_unwrap_mapper.dart';
import 'package:injectable/injectable.dart';

@singleton
class CommonExceptionMapper extends ExceptionMapperFacade {
  CommonExceptionMapper()
      : super(
          [
            NoInternetConnectionExceptionMapper(),
            UnauthorizedExceptionMapper(),
            ServerErrorExceptionMapper(),
            UnknownExceptionUnwrapMapper(),
          ],
        );
}
