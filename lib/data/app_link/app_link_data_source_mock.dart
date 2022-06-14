import 'dart:async';

import 'package:better_informed_mobile/data/app_link/app_link_data_source.dart';

class AppLinkDataSourceMock implements AppLinkDataSource {
  AppLinkDataSourceMock._();

  static Future<AppLinkDataSourceMock> create() async => AppLinkDataSourceMock._();

  @override
  Future<Uri?> getInitialAction() async => null;

  @override
  Stream<Uri> listenForIncomingActions() => Stream.value(Uri());

  @override
  Future<void> clear() async {}
}
