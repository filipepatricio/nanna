import 'dart:async';

import 'package:better_informed_mobile/data/app_link/app_link_data_source.dart';

class AppLinkDataSourceMock implements AppLinkDataSource {
  final StreamController<Uri> _appLinkStream = StreamController.broadcast();

  Uri? _initialRoute;
  StreamSubscription? _appLinkStreamSubscription;

  AppLinkDataSourceMock._();

  static Future<AppLinkDataSourceMock> create() async {
    return AppLinkDataSourceMock._();
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
