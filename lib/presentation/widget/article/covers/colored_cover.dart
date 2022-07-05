import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/article/article_editors_note.dart';
import 'package:better_informed_mobile/presentation/widget/article/covers/article_cover_shadow.dart';
import 'package:better_informed_mobile/presentation/widget/article/covers/dotted_article_info.dart';
import 'package:better_informed_mobile/presentation/widget/audio_icon.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ColoredCover extends StatelessWidget {
  const ColoredCover({
    required this.article,
    required this.backgroundColor,
    this.editorsNote,
    Key? key,
  }) : super(key: key);
  final MediaItemArticle article;
  final Color backgroundColor;
  final String? editorsNote;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppDimens.m),
        boxShadow: articleCoverShadows,
      ),
      width: double.infinity,
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
                          isLight: false,
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
                    baseTextStyle: AppTypography.h1SemiBold,
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
                showPublisher: false,
                isLight: false,
              ),
            ),
            if (editorsNote != null)
              ArticleEditorsNote(
                note: editorsNote!,
              ),
          ],
        ),
      ),
    );
  }
}
