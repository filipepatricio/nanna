import 'dart:async';

import 'package:better_informed_mobile/data/app_link/app_link_data_source.dart';
import 'package:fimber/fimber.dart';
import 'package:uni_links/uni_links.dart';

class AppLinkDataSourceImpl implements AppLinkDataSource {
  AppLinkDataSourceImpl._();
  final StreamController<Uri> _appLinkStream = StreamController.broadcast();

  Uri? _initialRoute;
  StreamSubscription? _appLinkStreamSubscription;

  static Future<AppLinkDataSourceImpl> create() async {
    final dataSource = AppLinkDataSourceImpl._();
    await dataSource._initialize();
    return dataSource;
  }

  Future<void> _initialize() async {
    try {
      _initialRoute = await getInitialUri();
    } catch (e, s) {
      Fimber.e('Getting initial link failed', ex: e, stacktrace: s);
    }

    _appLinkStreamSubscription = uriLinkStream.listen((event) {
      if (event != null) {
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
  }
}
