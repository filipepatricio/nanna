import 'package:better_informed_mobile/data/app_link/app_link_data_source.dart';
import 'package:better_informed_mobile/domain/deep_link/deep_link_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: DeepLinkRepository)
class DeepLinkRepositoryImpl implements DeepLinkRepository {
  DeepLinkRepositoryImpl(this._appLinkDataSource);
  final AppLinkDataSource _appLinkDataSource;

  bool _initialLinkHandled = false;

  @override
  Stream<String> subscribeForDeepLink() async* {
    final initialLink = _initialLinkHandled ? null : await _appLinkDataSource.getInitialAction();

    try {
      if (initialLink != null) {
        yield initialLink.path;
        _initialLinkHandled = true;
      }
    } finally {
      yield* _deepLinkStream();
    }
  }

  Stream<String> _deepLinkStream() => _appLinkDataSource.listenForIncomingActions().map((uri) => uri.path);
}
