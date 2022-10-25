import 'package:better_informed_mobile/data/app_link/app_link_data_source.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_facade.dart';
import 'package:better_informed_mobile/domain/deep_link/deep_link_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@LazySingleton(as: DeepLinkRepository)
class DeepLinkRepositoryImpl implements DeepLinkRepository {
  DeepLinkRepositoryImpl(this._appLinkDataSource, this._analyticsFacade);

  final AppLinkDataSource _appLinkDataSource;
  final AnalyticsFacade _analyticsFacade;

  bool _initialLinkHandled = false;

  @override
  Stream<String> subscribeForDeepLink() async* {
    _analyticsFacade.subscribeToAppsflyerDeepLink();
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

  Stream<String> _deepLinkStream() => Rx.concat(
        [
          _analyticsFacade.deepLinkStream,
          _appLinkDataSource.listenForIncomingActions().map((uri) => uri.path),
        ],
      ).distinct();
}
