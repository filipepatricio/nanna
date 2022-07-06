import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/presentation/page/media/article/article_image.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/article/article_editors_note.dart';
import 'package:better_informed_mobile/presentation/widget/article/covers/article_cover_shadow.dart';
import 'package:better_informed_mobile/presentation/widget/article/covers/dotted_article_info.dart';
import 'package:better_informed_mobile/presentation/widget/audio_icon.dart';
import 'package:better_informed_mobile/presentation/widget/cloudinary/cloudinary_image.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:flutter/material.dart';

class PhotoStackedCover extends StatelessWidget {
  const PhotoStackedCover({
    required this.article,
    this.editorsNote,
    Key? key,
  }) : super(key: key);
  final MediaItemArticle article;
  final String? editorsNote;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(AppDimens.m);
    final hasImage = article.hasImage;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: articleCoverShadows,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Stack(
          children: [
            if (hasImage) ...[
              Positioned.fill(
                child: ArticleImage(
                  image: article.image!,
                  darkeningMode: DarkeningMode.solid,
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
                              Flexible(
                                child: DottedArticleInfo(
                                  article: article,
                                  isLight: true,
                                  showDate: false,
                                  showReadTime: false,
                                ),
                              ),
                              if (article.hasAudioVersion) AudioIconButton(article: article),
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
                            maxLines: 4,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(left: AppDimens.l, bottom: AppDimens.l),
                      child: DottedArticleInfo(
                        article: article,
                        isLight: true,
                        showPublisher: false,
                      ),
                    ),
                    if (editorsNote != null)
                      ArticleEditorsNote(
                        note: editorsNote!,
                      ),
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
