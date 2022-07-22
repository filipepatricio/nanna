import 'dart:io';

import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/share/data/share_app.dart';
import 'package:better_informed_mobile/domain/share/share_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ShareRepository, env: mockEnvs)
class ShareRepositoryMock implements ShareRepository {
  @override
  Future<List<ShareApp>> getShareableApps() async {
    return [
      ShareApp.instagram,
      ShareApp.facebook,
      ShareApp.copyLink,
      ShareApp.message,
      ShareApp.more,
      ShareApp.telegram,
      ShareApp.twitter,
      ShareApp.whatsapp,
    ];
  }

  @override
  Future<void> shareImage(ShareApp shareApp, File image, [String? text, String? subject]) async {}

  @override
  Future<void> shareText(ShareApp shareApp, String text, [String? subject]) async {}

  @override
  Future<void> shareUsingInstagram(File foregroundFile, File? backgroundFile, String url) async {}

  @override
  Future<void> shareFacebookStory(File foregroundFile, String url) async {}
}
