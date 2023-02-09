import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';

enum ShareOption { instagram, facebook, whatsapp, copyLink, more }

extension ShareExtension on ShareOption {
  String getText() {
    switch (this) {
      case ShareOption.instagram:
        return LocaleKeys.social_instagram.tr();
      case ShareOption.facebook:
        return LocaleKeys.social_facebook.tr();
      case ShareOption.whatsapp:
        return LocaleKeys.social_whatsapp.tr();
      case ShareOption.copyLink:
        return LocaleKeys.common_copyLink.tr();
      case ShareOption.more:
        return LocaleKeys.common_more.tr();
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
