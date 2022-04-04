import 'package:better_informed_mobile/data/networking/app_version_link/app_version_link_transformer.di.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

@injectable
class AppVersionLink extends Link {
  final AppVersionLinkTransformer _appVersionLinkTransformer;

  AppVersionLink(this._appVersionLinkTransformer);

  @override
  Stream<Response> request(Request request, [NextLink? forward]) async* {
    final updatedRequest = await _appVersionLinkTransformer(request);
    yield* forward!(updatedRequest);
  }
}
