import 'dart:io';

import 'package:better_informed_mobile/domain/share/data/share_app.dart';

abstract class ShareRepository {
  Future<List<ShareOptions>> getShareOptions();

  Future<void> shareImage(ShareOptions shareOption, File image, [String? text, String? subject]);

  Future<void> shareText(ShareOptions shareOption, String text, [String? subject]);

  Future<void> shareUsingInstagram(File foregroundFile, File? backgroundFile, String url);

  Future<void> shareFacebookStory(File foregroundFile, String url);
}
