import 'dart:io';

import 'package:better_informed_mobile/domain/share/data/share_options.dart';

abstract class ShareRepository {
  Future<List<ShareOption>> getShareOptions();

  Future<void> shareImage(ShareOption shareOption, File image, [String? text, String? subject]);

  Future<void> shareText(ShareOption shareOption, String text, [String? subject]);

  Future<void> shareUsingInstagram(File foregroundFile, File? backgroundFile, String url);

  Future<void> shareFacebookStory(File foregroundFile, String url);
}
