import 'dart:async';

import 'package:better_informed_mobile/data/app_link/app_link_data_source.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';
import 'package:uni_links/uni_links.dart';

class AppLinkDataSourceImpl implements AppLinkDataSource {
  final StreamController<String> _appLinkStream = StreamController.broadcast();

  String? _initialRoute;
  StreamSubscription? _appLinkStreamSubscription;

  AppLinkDataSourceImpl._();

  static Future<AppLinkDataSourceImpl> create() async {
    final dataSource = AppLinkDataSourceImpl._();
    await dataSource._initialize();
    return dataSource;
  }

  Future<void> _initialize() async {
    try {
      _initialRoute = await getInitialLink();
    } catch (e, s) {
      Fimber.e('Getting initial link failed', ex: e, stacktrace: s);
    }

    _appLinkStreamSubscription = linkStream.listen((event) {
      if (event != null) {
        _appLinkStream.sink.add(event);
      }
    });
  }

  @override
  Future<String?> getInitialAction() async {
    return _initialRoute;
  }

  @override
  Stream<String> listenForIncomingActions() => _appLinkStream.stream;

  @override
  Future<void> clear() async {
    await _appLinkStreamSubscription?.cancel();
  }
}
