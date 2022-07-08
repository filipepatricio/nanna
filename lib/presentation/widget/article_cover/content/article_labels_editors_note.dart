import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/article_cover/article_cover.dart';
import 'package:better_informed_mobile/presentation/widget/audio/control_button/audio_floating_control_button.dart';
import 'package:better_informed_mobile/presentation/widget/cover_label/cover_label.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:flutter/material.dart';

class ArticleLabelsEditorsNote extends StatelessWidget {
  const ArticleLabelsEditorsNote({
    required this.article,
    this.coverType,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;
  final ArticleCoverType? coverType;

  @override
  Widget build(BuildContext context) {
    final kind = article.kind;
    final note = article.note;

    // Overlapping top border for editor's note is handled by [_ArticleCoverDailyBriefLarge]
    final decoration = coverType == ArticleCoverType.dailyBriefLarge
        ? const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(AppDimens.m),
              bottomRight: Radius.circular(AppDimens.m),
            ),
          )
        : BoxDecoration(
            color: AppColors.white,
            border: Border.all(width: AppDimens.one, color: AppColors.darkLinen),
            borderRadius: BorderRadius.circular(AppDimens.m),
          );

    final padding = coverType == ArticleCoverType.dailyBriefLarge
        ? const EdgeInsets.fromLTRB(
            AppDimens.m,
            AppDimens.zero,
            AppDimens.m,
            AppDimens.m,
          )
        : const EdgeInsets.all(AppDimens.m);

    final margin = coverType == ArticleCoverType.dailyBriefLarge
        ? const EdgeInsets.fromLTRB(
            AppDimens.one,
            AppDimens.zero,
            AppDimens.one,
            AppDimens.one,
          )
        : EdgeInsets.zero;

    return ColoredBox(
      color: AppColors.darkLinen,
      child: Container(
        decoration: decoration,
        padding: padding,
        margin: margin,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (note != null) ...[
              InformedMarkdownBody(
                markdown: note,
                baseTextStyle: AppTypography.b3Medium.copyWith(
                  color: AppColors.textGrey,
                ),
                maxLines: 6,
              ),
              const SizedBox(height: AppDimens.s),
            ],
            Row(
              children: [
                if (kind != null) CoverLabel.articleKind(kind),
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
      ),
    );
  }
}
