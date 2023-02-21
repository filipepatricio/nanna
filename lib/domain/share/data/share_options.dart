import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:flutter/material.dart';

enum ShareOption { instagram, facebook, whatsapp, copyLink, more }

extension ShareExtension on ShareOption {
  String getText(BuildContext context) {
    switch (this) {
      case ShareOption.instagram:
        return context.l10n.social_instagram;
      case ShareOption.facebook:
        return context.l10n.social_facebook;
      case ShareOption.whatsapp:
        return context.l10n.social_whatsapp;
      case ShareOption.copyLink:
        return context.l10n.common_copyLink;
      case ShareOption.more:
        return context.l10n.common_more;
    }
  }

  String? getIcon() {
    switch (this) {
      case ShareOption.copyLink:
        return AppVectorGraphics.copy;
      case ShareOption.more:
        return AppVectorGraphics.more;
      default:
        return null;
    }
  }
}
