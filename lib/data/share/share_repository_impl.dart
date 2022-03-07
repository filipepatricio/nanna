import 'dart:io';

import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/share/data/share_app.dart';
import 'package:better_informed_mobile/domain/share/share_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:share_plus/share_plus.dart';
import 'package:social_share/social_share.dart';

const _socialShareApps = {
  'instagram': ShareApp.instagram,
};

@LazySingleton(as: ShareRepository, env: liveEnvs)
class ShareRepositoryImpl implements ShareRepository {
  @override
  Future<List<ShareApp>> getShareableApps() async {
    final apps = await SocialShare.checkInstalledAppsForShare() as Map<String, bool>?;
    if (apps == null) return [];

    return apps.entries
        .where((entry) => _socialShareApps.containsKey(entry.key))
        .where((entry) => entry.value)
        .map((entry) => _socialShareApps[entry.key])
        .whereType<ShareApp>()
        .toList();
  }

  @override
  Future<void> shareImage(File image, [String? text]) async {
    await Share.shareFiles([image.path], text: text);
  }

  @override
  Future<void> shareText(String text) async {
    await Share.share(text);
  }

  @override
  Future<void> shareUsingInstagram(File foregroundFile, File backgroundFile, String url) async {
    await SocialShare.shareInstagramStory(
      foregroundFile.path,
      backgroundImagePath: backgroundFile.path,
      attributionURL: url,
      backgroundBottomColor: '',
      backgroundTopColor: '',
    );
  }
}
