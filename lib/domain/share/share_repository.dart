import 'dart:io';

import 'package:better_informed_mobile/domain/share/data/share_app.dart';

abstract class ShareRepository {
  Future<List<ShareApp>> getShareableApps();

  Future<void> shareImage(File image, [String? text, String? subject]);

  Future<void> shareText(String text, [String? subject]);

  Future<void> shareUsingInstagram(File foregroundFile, File backgroundFile, String url);
}
