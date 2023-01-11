import 'dart:io';

import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/share/data/share_options.dart';
import 'package:better_informed_mobile/domain/share/share_repository.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:injectable/injectable.dart';
import 'package:share_plus/share_plus.dart';
import 'package:social_share/social_share.dart';

const _socialShareOptions = {
  'instagram': ShareOption.instagram,
  'facebook': ShareOption.facebook,
  'whatsapp': ShareOption.whatsapp,
};

@LazySingleton(as: ShareRepository, env: defaultEnvs)
class ShareRepositoryImpl implements ShareRepository {
  @override
  Future<List<ShareOption>> getShareOptions() async {
    final apps = await SocialShare.checkInstalledAppsForShare();
    final entries = apps?.entries.map((e) => MapEntry(e.key as String, e.value as bool)).toList();

    if (entries == null) return [];

    return entries
        .where((entry) => _socialShareOptions.containsKey(entry.key))
        .where((entry) => entry.value)
        .map((entry) => _socialShareOptions[entry.key])
        .whereType<ShareOption>()
        .toList()
      ..addAll([ShareOption.copyLink, ShareOption.more]);
  }

  @override
  Future<void> shareImage(ShareOption shareOption, File image, [String? text, String? subject]) async {
    await SocialShare.shareOptions('${subject ?? ''}\n\n${text ?? ''}\n', imagePath: image.path);
  }

  @override
  Future<void> shareText(ShareOption shareOption, String text, [String? subject]) async {
    switch (shareOption) {
      case ShareOption.whatsapp:
        await SocialShare.shareWhatsapp(text);
        break;
      case ShareOption.copyLink:
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
      backgroundBottomColor: AppColors.shareBackgroundBottomColor,
      backgroundTopColor: AppColors.shareBackgroundTopColor,
    );
  }

  @override
  Future<void> shareFacebookStory(File foregroundFile, String url) async {
    await SocialShare.shareFacebookStory(
      foregroundFile.path,
      AppColors.shareBackgroundTopColor,
      AppColors.shareBackgroundBottomColor,
      url,
    );
  }
}
