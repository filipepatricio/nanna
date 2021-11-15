import 'package:better_informed_mobile/domain/article/data/article.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/article/covers/dotted_article_info.dart';
import 'package:better_informed_mobile/presentation/page/media/media_item_page.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ArticleImageView extends HookWidget {
  final MediaItemArticle article;
  final ScrollController controller;
  const ArticleImageView({
    required this.article,
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cloudinaryProvider = useCloudinaryProvider();
    final imageId = article.image?.publicId;
    final titleOpacityState = useState(1.0);
    final fullHeight = articleViewFullHeight(context);
    final halfHeight = fullHeight / 2;

    void setTitleOpacity() {
      if (controller.hasClients) {
        final currentOffset = controller.offset;
        final opacityThreshold = halfHeight * 1.5;

        if (currentOffset <= 0) {
          if (titleOpacityState.value != 1) titleOpacityState.value = 1;
          return;
        }

        if (currentOffset > opacityThreshold) {
          if (titleOpacityState.value != 0) titleOpacityState.value = 0;
          return;
        }

        titleOpacityState.value = 1 - (currentOffset / opacityThreshold);
      }
    }

    useEffect(() {
      controller.addListener(setTitleOpacity);
      return () => controller.removeListener(setTitleOpacity);
    }, [controller]);

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        if (imageId != null) ...[
          SizedBox(
            width: double.infinity,
            height: fullHeight,
            child: Image.network(
              cloudinaryProvider.withPublicIdAsPng(imageId).url,
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
        ] else
          Container(color: AppColors.background),
        Positioned.fill(
          child: Container(
            color: AppColors.black.withOpacity(0.40),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: AppDimens.l, right: AppDimens.l, bottom: AppDimens.l),
          child: Opacity(
            opacity: titleOpacityState.value,
            child: SizedBox(
              width: double.infinity,
              // height: halfHeight,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DottedArticleInfo(
                    article: article,
                    isLight: true,
                    showDate: false,
                    showReadTime: false,
                  ),
                  const SizedBox(height: AppDimens.m),
                  Padding(
                    padding: const EdgeInsets.only(right: AppDimens.l),
                    child: Text(
                      article.title, // TODO missing data in object
                      style: AppTypography.h0Bold.copyWith(color: AppColors.white),
                    ),
                  ),
                  const SizedBox(height: AppDimens.xxxl),
                  GestureDetector(
                    onTap: () => controller.animateTo(halfHeight,
                        duration: const Duration(milliseconds: 200), curve: Curves.easeIn),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Continue reading',
                          style: AppTypography.h3Bold
                              .copyWith(color: AppColors.white, decoration: TextDecoration.underline),
                        ),
                        const Icon(Icons.keyboard_arrow_up_rounded, color: AppColors.white, size: AppDimens.m),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimens.l),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
          child: Container(
            decoration: BoxDecoration(
              color: article.type == ArticleType.freemium ? AppColors.darkLinen : AppColors.pastelGreen,
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withOpacity(0.4),
                  offset: const Offset(0, -AppDimens.xs),
                  blurRadius: AppDimens.xs,
                ),
              ],
            ),
            width: double.infinity,
            height: AppDimens.sl,
          ),
        )
      ],
    );
  }
}
