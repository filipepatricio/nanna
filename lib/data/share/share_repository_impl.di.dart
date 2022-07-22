import 'dart:io';

import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/share/data/share_app.dart';
import 'package:better_informed_mobile/domain/share/share_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:share_plus/share_plus.dart';
import 'package:social_share/social_share.dart';

const _socialShareApps = {
  'instagram': ShareApp.instagram,
  'twitter': ShareApp.twitter,
  // 'telegram': ShareApp.telegram,
  'whatsapp': ShareApp.whatsapp,
  'sms': ShareApp.message,
  // At the moment the application crashes if I want to share on Facebook story,
  // so for the moment this option is commented :D
  // 'facebook': ShareApp.facebook,
};

@LazySingleton(as: ShareRepository, env: liveEnvs)
class ShareRepositoryImpl implements ShareRepository {
  @override
  Future<List<ShareApp>> getShareableApps() async {
    final apps = await SocialShare.checkInstalledAppsForShare();
    final entries = apps?.entries.map((e) => MapEntry(e.key as String, e.value as bool)).toList();

    if (entries == null) return [];

    return entries
        .where((entry) => _socialShareApps.containsKey(entry.key))
        .where((entry) => entry.value)
        .map((entry) => _socialShareApps[entry.key])
        .whereType<ShareApp>()
        .toList()
      ..addAll([ShareApp.copyLink, ShareApp.more]);
  }

  @override
  Future<void> shareImage(ShareApp shareApp, File image, [String? text, String? subject]) async {
    switch (shareApp) {
      default:
        await SocialShare.shareOptions('${subject ?? ''}\n\n${text ?? ''}\n', imagePath: image.path);
    }
  }

  @override
  Future<void> shareText(ShareApp shareApp, String text, [String? subject]) async {
    switch (shareApp) {
      case ShareApp.twitter:
        await SocialShare.shareTwitter(
          '${subject ?? ''}\n\n$text\n',
          hashtags: ['informed'],
        );
        break;
      case ShareApp.whatsapp:
        await SocialShare.shareWhatsapp(text);
        break;
      case ShareApp.telegram:
        await SocialShare.shareTelegram(text);
        break;
      case ShareApp.message:
        await SocialShare.shareSms(text);
        break;
      case ShareApp.copyLink:
        await SocialShare.copyToClipboard(text);
        break;
      default:
        await Share.share(text, subject: subject);
    }
  }

  @override
  Future<void> shareUsingInstagram(File foregroundFile, File? backgroundFile, String url) async {
    await SocialShare.shareInstagramStory(
      foregroundFile.path,
      backgroundImagePath: backgroundFile?.path,
      attributionURL: url,
      backgroundBottomColor: '#FFFFFF',
      backgroundTopColor: '#FFFFFF',
    );
  }

  @override
  Future<void> shareFacebookStory(File foregroundFile, String url) async {
    await SocialShare.shareFacebookStory(
      foregroundFile.path,
      '#FFFFFF',
      '#FFFFFF',
      url,
      appId: '249845939148351',
    );
  }
}
