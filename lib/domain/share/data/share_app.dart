import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';

enum ShareOptions {
  instagram,
  facebook,
  whatsapp,
  copyLink,
  more,
}

extension ShareExtension on ShareOptions {
  String getText() {
    switch (this) {
      case ShareOptions.instagram:
        return LocaleKeys.social_instagram.tr();
      case ShareOptions.facebook:
        return LocaleKeys.social_facebook.tr();
      case ShareOptions.whatsapp:
        return LocaleKeys.social_whatsapp.tr();
      case ShareOptions.copyLink:
        return LocaleKeys.common_copyLink.tr();
      case ShareOptions.more:
        return LocaleKeys.common_more.tr();
    }
  }

  String? getIcon() {
    if (this == ShareOptions.copyLink) {
      return AppVectorGraphics.shareCopy;
    }

    if (this == ShareOptions.more) {
      return AppVectorGraphics.shareMore;
    }
  }
}
