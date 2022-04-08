import 'dart:io';

import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/share/data/share_app.dart';
import 'package:better_informed_mobile/domain/share/share_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ShareRepository, env: mockEnvs)
class ShareRepositoryMock implements ShareRepository {
  @override
  Future<List<ShareApp>> getShareableApps() async {
    return [ShareApp.instagram];
  }

  @override
  Future<void> shareImage(File image, [String? text]) async {}

  @override
  Future<void> shareText(String text) async {}

  @override
  Future<void> shareUsingInstagram(File foregroundFile, File backgroundFile, String url) async {}
}
