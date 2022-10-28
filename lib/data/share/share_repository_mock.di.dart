import 'dart:io';

import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/share/data/share_options.dart';
import 'package:better_informed_mobile/domain/share/share_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ShareRepository, env: mockEnvs)
class ShareRepositoryMock implements ShareRepository {
  @override
  Future<List<ShareOption>> getShareOptions() async {
    return [
      ShareOption.instagram,
      ShareOption.facebook,
      ShareOption.copyLink,
      ShareOption.more,
      ShareOption.whatsapp,
    ];
  }

  @override
  Future<void> shareImage(ShareOption shareOption, File image, [String? text, String? subject]) async {}

  @override
  Future<void> shareText(ShareOption shareOption, String text, [String? subject]) async {}

  @override
  Future<void> shareUsingInstagram(File foregroundFile, File? backgroundFile, String url) async {}

  @override
  Future<void> shareFacebookStory(File foregroundFile, String url) async {}
}
