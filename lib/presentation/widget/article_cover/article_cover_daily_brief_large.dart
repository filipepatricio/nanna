import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/presentation/page/media/article/article_image.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/article/article_labels_editors_note.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/article/covers/article_cover_shadow.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/article/covers/dotted_article_info.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/audio_icon.dart';
import 'package:flutter/material.dart';

class ArticleCoverDailyBriefLarge extends StatelessWidget {
  final MediaItemArticle article;
  final String? editorsNote;

  const ArticleCoverDailyBriefLarge({
    required this.article,
    this.editorsNote,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(AppDimens.m);
    final hasImage = article.hasImage;

    return Container(
      width: double.infinity,
      height: AppDimens.articleLargeImageCoverHeight,
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
                  showDarkened: true,
                ),
              ),
            ],
            Align(
              alignment: Alignment.topLeft,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppDimens.m,
                        AppDimens.m,
                        AppDimens.m,
                        AppDimens.l,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  showLogo: true,
                                  showPublisher: true,
                                  textStyle: AppTypography.metadata1Medium,
                                ),
                              ),
                              if (article.hasAudioVersion) AudioIcon.light(),
                            ],
                          ),
                          Text(
                            article.strippedTitle,
                            style: AppTypography.h4ExtraBold.copyWith(
                              color: AppColors.white,
                              overflow: TextOverflow.ellipsis,
                              height: 1.7,
                            ),
                            maxLines: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                  ArticleLabelsEditorsNote(
                    note: editorsNote,
                    article: article,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
