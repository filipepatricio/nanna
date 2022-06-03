import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/audio/control_button/audio_floating_control_button.dart';
import 'package:better_informed_mobile/presentation/widget/cover_label/cover_label.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:flutter/material.dart';

class ArticleLabelsEditorsNote extends StatelessWidget {
  final MediaItemArticle article;
  final String? note;

  const ArticleLabelsEditorsNote({
    required this.article,
    this.note,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final articleKind = article.kind;
    final shouldShowArticlesNote = note != null || articleKind != null || article.hasAudioVersion;
    return !shouldShowArticlesNote
        ? const SizedBox()
        : Container(
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(
              AppDimens.m,
            ),
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
                    maxLines: 4,
                  ),
                  const SizedBox(height: AppDimens.s),
                ],
                Row(
                  children: [
                    if (articleKind != null) CoverLabel.articleKind(articleKind),
                    const Spacer(),
                    if (article.hasAudioVersion)
                      SizedBox(
                        width: AppDimens.xxl + AppDimens.xxs,
                        height: AppDimens.xxl + AppDimens.xxs,
                        child: AudioFloatingControlButton(
                          article: article,
                          elevation: 0,
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
