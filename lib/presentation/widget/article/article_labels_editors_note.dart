import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/audio/control_button/audio_floating_control_button.dart';
import 'package:better_informed_mobile/presentation/widget/cover_label/cover_label.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:flutter/material.dart';

class ArticleLabelsEditorsNote extends StatelessWidget {
  const ArticleLabelsEditorsNote({
    required this.article,
    this.note,
    Key? key,
  }) : super(key: key);
  final MediaItemArticle article;
  final String? note;

  @override
  Widget build(BuildContext context) {
    final articleKind = article.kind;
    final shouldShowArticlesNote = note != null || articleKind != null || article.hasAudioVersion;
    return !shouldShowArticlesNote
        ? const SizedBox()
        : Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border.all(width: AppDimens.one, color: AppColors.darkLinen),
              borderRadius: BorderRadius.circular(AppDimens.m),
            ),
            padding: const EdgeInsets.all(AppDimens.m),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (note != null) ...[
                  InformedMarkdownBody(
                    markdown: note!,
                    baseTextStyle: AppTypography.b3Medium.copyWith(
                      color: AppColors.textGrey,
                    ),
                    maxLines: 6,
                  ),
                  const SizedBox(height: AppDimens.s),
                ],
                Row(
                  children: [
                    if (articleKind != null) CoverLabel.articleKind(articleKind),
                    const Spacer(),
                    if (article.hasAudioVersion)
                      Container(
                        width: AppDimens.xxl + AppDimens.xxs,
                        height: AppDimens.xxl + AppDimens.xxs,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: AppColors.black05, blurRadius: 5.0),
                          ],
                        ),
                        child: AudioFloatingControlButton(
                          article: article,
                          elevation: 0,
                          color: AppColors.white,
                          imageHeight: AppDimens.sl + AppDimens.xxs,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          );
  }
}
