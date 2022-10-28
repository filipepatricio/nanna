import 'dart:io';

import 'package:better_informed_mobile/domain/share/data/share_options.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'share_content.dt.freezed.dart';

@freezed
class ShareContent with _$ShareContent {
  factory ShareContent.facebook(
    File foregroundFile,
    String url,
  ) = _ShareContentFacebook;

  factory ShareContent.instagram(
    File foregroundFile,
    File? backgroundFile,
    String url,
  ) = _ShareContentInstagram;

  factory ShareContent.text(
    ShareOption shareOption,
    String text, [
    String? subject,
  ]) = _ShareContentText;

  factory ShareContent.image(
    ShareOption shareOption,
    File image, [
    String? text,
    String? subject,
  ]) = _ShareContentImage;
}
