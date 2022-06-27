import 'package:better_informed_mobile/data/networking/timezone_link/timezone_link_transformer.di.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

@injectable
class TimezoneLink extends Link {
  TimezoneLink(this._timezoneLinkTransformer);
  final TimezoneLinkTransformer _timezoneLinkTransformer;

  @override
  Stream<Response> request(Request request, [NextLink? forward]) async* {
    final updatedRequest = await _timezoneLinkTransformer(request);
    yield* forward!(updatedRequest);
  }
}
