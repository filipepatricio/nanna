import 'dart:async';

import 'package:better_informed_mobile/data/app_link/app_link_data_source.dart';
import 'package:uni_links/uni_links.dart';

class AppLinkDataSourceMock implements AppLinkDataSource {
  final StreamController<Uri> _appLinkStream = StreamController.broadcast();

  Uri? _initialRoute;
  StreamSubscription? _appLinkStreamSubscription;

  AppLinkDataSourceMock._();

  static Future<AppLinkDataSourceMock> create() async {
    final dataSource = AppLinkDataSourceMock._();
    try {
      await dataSource._initialize();
    } catch (_) {}
    return dataSource;
  }

  Future<void> _initialize() async {
    try {
      _initialRoute = await getInitialUri();
    } catch (_) {}
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
