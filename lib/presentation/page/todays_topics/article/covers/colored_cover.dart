import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/article/article_editors_note.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/article/covers/dotted_article_info.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/shadow_util.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ColoredCover extends StatelessWidget {
  final MediaItemArticle article;
  final Color backgroundColor;
  final String? editorsNote;

  const ColoredCover({
    required this.article,
    required this.backgroundColor,
    this.editorsNote,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppDimens.m),
        boxShadow: articleCardShadows,
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
                children: [
                  DottedArticleInfo(
                    article: article,
                    isLight: false,
                    showDate: false,
                    showReadTime: false,
                    showLogo: true,
                    showPublisher: true,
                  ),
                  const SizedBox(height: AppDimens.m),
                  InformedMarkdownBody(
                    markdown: article.title,
                    baseTextStyle: AppTypography.h1SemiBold,
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
                isLight: false,
              ),
            ),
            if (editorsNote != null) ArticleEditorsNote(note: editorsNote!),
          ],
        ),
      ),
    );
  }
}
