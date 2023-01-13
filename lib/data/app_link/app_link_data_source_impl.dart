import 'dart:async';

import 'package:better_informed_mobile/data/app_link/app_link_data_source.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:fimber/fimber.dart';
import 'package:uni_links/uni_links.dart';

class AppLinkDataSourceImpl implements AppLinkDataSource {
  AppLinkDataSourceImpl._(this.appConfig);

  final AppConfig appConfig;

  final StreamController<Uri> _appLinkStream = StreamController.broadcast();

  Uri? _initialRoute;
  StreamSubscription? _appLinkStreamSubscription;

  static Future<AppLinkDataSourceImpl> create(AppConfig appConfig) async {
    final dataSource = AppLinkDataSourceImpl._(appConfig);
    await dataSource._initialize();
    return dataSource;
  }

  Future<void> _initialize() async {
    try {
      final initial = await getInitialUri();
      _initialRoute = initial != null && _isNotForbidden(initial) ? initial : null;
    } catch (e, s) {
      Fimber.e('Getting initial link failed', ex: e, stacktrace: s);
    }

    _appLinkStreamSubscription = uriLinkStream.listen((event) {
      if (event != null && _isNotForbidden(event)) {
        _appLinkStream.sink.add(event);
      }
    });
  }

  @override
  Future<Uri?> getInitialAction() async {
    return _initialRoute;
  }

  @override
  Stream<Uri> listenForIncomingActions() => _appLinkStream.stream;

  @override
  Future<void> clear() async {
    await _appLinkStreamSubscription?.cancel();
    await _appLinkStream.close();
  }

  bool _isNotForbidden(Uri event) => !appConfig.appsFlyerLinkPath.contains(event.path);
}
