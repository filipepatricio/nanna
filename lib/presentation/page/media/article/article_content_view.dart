import 'package:better_informed_mobile/domain/article/data/article.dart';
import 'package:better_informed_mobile/domain/article/data/article_content_type.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/media/content/article_content_html.dart';
import 'package:better_informed_mobile/presentation/page/media/content/article_content_markdown.dart';
import 'package:better_informed_mobile/presentation/page/media/media_item_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/article/covers/dotted_article_info.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/share/quote/quote_editor_view.dart';
import 'package:flutter/material.dart';

class ArticleContentView extends StatelessWidget {
  final Article article;
  final MediaItemCubit cubit;
  final ScrollController controller;
  final Key articleContentKey;
  final Function() scrollToPosition;

  const ArticleContentView({
    required this.article,
    required this.cubit,
    required this.controller,
    required this.articleContentKey,
    required this.scrollToPosition,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: MediaQuery.of(context).padding.top),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
          child: _ArticleHeader(article: article.metadata),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              key: articleContentKey,
              child: _articleContent(context),
            ),
          ],
        ),
      ],
    );
  }

  Widget? _articleContent(BuildContext context) {
    if (article.content.type == ArticleContentType.markdown) {
      return ArticleContentMarkdown(
        markdown: article.content.content,
        shareTextCallback: (quote) {
          showQuoteEditor(
            context,
            article.metadata,
            quote,
          );
        },
        scrollToPosition: scrollToPosition,
      );
    } else if (article.content.type == ArticleContentType.html) {
      return ArticleContentHtml(
        html: article.content.content,
        cubit: cubit,
        scrollToPosition: scrollToPosition,
      );
    }
    return null;
  }
}

class _ArticleHeader extends StatelessWidget {
  const _ArticleHeader({required this.article, Key? key}) : super(key: key);

  final MediaItemArticle article;

  @override
  Widget build(BuildContext context) {
    final author = article.author;
    final metadataStyle = AppTypography.systemText.copyWith(color: AppColors.textGrey, height: 1.5);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppDimens.xxc),
        if (author != null) ...[
          Text(
            LocaleKeys.article_byName.tr(args: [author]),
            style: metadataStyle,
          ),
          const SizedBox(height: AppDimens.m),
        ],
        InformedMarkdownBody(
          markdown: article.title,
          baseTextStyle: AppTypography.h1ExtraBold,
          highlightColor: AppColors.transparent,
          shareTextCallback: (quote) {
            showQuoteEditor(
              context,
              article,
              quote,
            );
          },
        ),
        const SizedBox(height: AppDimens.m),
        DottedArticleInfo(
          article: article,
          isLight: false,
          showLogo: false,
          textStyle: metadataStyle,
          color: metadataStyle.color,
          publisherMaxLines: 2,
        ),
        const SizedBox(height: AppDimens.xl),
        const Divider(
          height: 0.5,
          color: AppColors.dividerGreyLight,
          indent: AppDimens.xxl,
          endIndent: AppDimens.xxl,
        ),
        const SizedBox(height: AppDimens.xl),
      ],
    );
  }
}
