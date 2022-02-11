import 'package:better_informed_mobile/domain/daily_brief/data/entry_style.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/article/covers/colored_cover.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/article/covers/photo_stacked_cover.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/link_label.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ArticleItemView extends HookWidget {
  final Function() onTap;
  final MediaItemArticle article;
  final EntryStyle entryStyle;
  final String? entryNote;
  final GlobalKey? mediaItemKey;

  const ArticleItemView({
    required this.onTap,
    required this.article,
    required this.entryStyle,
    required this.entryNote,
    this.mediaItemKey,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        entryStyle.type == EntryStyleType.articleCoverWithoutImage ? AppColors.background : entryStyle.color;

    return Container(
      color: backgroundColor,
      height: AppDimens.topicViewMediaItemMaxHeight(context),
      padding: const EdgeInsets.all(AppDimens.l),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 11,
              child: _ArticleCover(
                entryStyle: entryStyle,
                article: article,
                mediaItemKey: mediaItemKey,
              ),
            ),
            const Spacer(),
            Expanded(
              flex: 10,
              child: _EditorsNote(note: entryNote),
            ),
            const Spacer(),
            LinkLabel(
              labelText: LocaleKeys.article_readMore.tr(),
              fontSize: AppDimens.m,
              onTap: onTap,
            ),
          ],
        ),
      ),
    );
  }
}

class _ArticleCover extends StatelessWidget {
  final EntryStyle entryStyle;
  final MediaItemArticle article;
  final GlobalKey? mediaItemKey;

  const _ArticleCover({
    required this.entryStyle,
    required this.article,
    required this.mediaItemKey,
  });

  @override
  Widget build(BuildContext context) {
    switch (entryStyle.type) {
      case EntryStyleType.articleCoverWithBigImage:
        return PhotoStackedCover(
          article: article,
          key: mediaItemKey,
        );
      case EntryStyleType.articleCoverWithoutImage:
        return ColoredCover(
          backgroundColor: entryStyle.color,
          article: article,
          key: mediaItemKey,
        );
    }
  }
}

class _EditorsNote extends StatelessWidget {
  final String? note;

  const _EditorsNote({required this.note, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return note != null
        ? InformedMarkdownBody(
            markdown: note!,
            baseTextStyle: AppTypography.b2RegularLora,
            maxLines: 6,
          )
        : const SizedBox();
  }
}
