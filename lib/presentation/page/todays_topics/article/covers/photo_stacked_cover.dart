import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/article/article_editors_note.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/article/covers/dotted_article_info.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/app_raster_graphics.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/util/shadow_util.dart';
import 'package:better_informed_mobile/presentation/widget/cloudinary_progressive_image.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

class PhotoStackedCover extends HookWidget {
  final MediaItemArticle article;
  final String? editorsNote;

  const PhotoStackedCover({
    required this.article,
    this.editorsNote,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cloudinaryProvider = useCloudinaryProvider();
    final imageId = article.image?.publicId;
    final borderRadius = BorderRadius.circular(AppDimens.m);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: articleCardShadows,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Stack(
          children: [
            if (imageId != null) ...[
              Positioned.fill(
                child: LayoutBuilder(
                  builder: (context, constrains) {
                    return CloudinaryProgressiveImage(
                      testImage: AppRasterGraphics.testArticleHeroImage,
                      cloudinaryTransformation: cloudinaryProvider
                          .withPublicIdAsPlatform(imageId)
                          .transform()
                          .withLogicalSize(constrains.maxWidth, constrains.maxHeight, context)
                          .autoGravity(),
                      height: constrains.maxHeight,
                      width: constrains.maxWidth,
                    );
                  },
                ),
              ),
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.40),
                ),
              ),
            ],
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: AppDimens.l),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              DottedArticleInfo(
                                article: article,
                                isLight: true,
                                showDate: false,
                                showReadTime: false,
                                showLogo: true,
                                showPublisher: true,
                              ),
                              if (article.hasAudioVersion) ...[
                                SvgPicture.asset(
                                  AppVectorGraphics.headphones,
                                  height: AppDimens.ml,
                                  color: AppColors.white,
                                )
                              ],
                            ],
                          ),
                          const SizedBox(height: AppDimens.m),
                          InformedMarkdownBody(
                            markdown: article.title,
                            baseTextStyle: AppTypography.h1Bold.copyWith(
                              color: AppColors.white,
                              overflow: TextOverflow.ellipsis,
                            ),
                            highlightColor: AppColors.transparent,
                            maxLines: 5,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(left: AppDimens.l, bottom: AppDimens.l),
                      child: DottedArticleInfo(
                        article: article,
                        showPublisher: false,
                        isLight: true,
                      ),
                    ),
                    if (editorsNote != null) ArticleEditorsNote(note: editorsNote!),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
