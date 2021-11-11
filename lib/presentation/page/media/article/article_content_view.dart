import 'package:better_informed_mobile/domain/article/data/article.dart';
import 'package:better_informed_mobile/domain/article/data/article_content.dart';
import 'package:better_informed_mobile/domain/article/data/article_content_type.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/article/covers/dotted_article_info.dart';
import 'package:better_informed_mobile/presentation/page/media/content/article_content_html.dart';
import 'package:better_informed_mobile/presentation/page/media/content/article_content_markdown.dart';
import 'package:better_informed_mobile/presentation/page/media/media_item_cubit.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ArticleContentView extends StatelessWidget {
  final MediaItemArticle article;
  final ArticleContent content;
  final MediaItemCubit cubit;
  final ScrollController controller;
  final Key articleContentKey;
  final Function() scrollToPosition;

  const ArticleContentView({
    required this.article,
    required this.content,
    required this.cubit,
    required this.controller,
    required this.articleContentKey,
    required this.scrollToPosition,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ArticleHeader(article: article),
          const SizedBox(height: AppDimens.xl),
          Container(
            key: articleContentKey,
            child: articleContent(),
          ),
          const SizedBox(height: AppDimens.l),
        ],
      ),
    );
  }

  Widget? articleContent() {
    if (content.type == ArticleContentType.markdown) {
      return ArticleContentMarkdown(
        markdown: content.content,
        scrollToPosition: scrollToPosition,
      );
    } else if (content.type == ArticleContentType.html) {
      return ArticleContentHtml(
        html: content.content,
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
    return Container(
      color: article.type == ArticleType.freemium ? AppColors.darkLinen : AppColors.pastelGreen,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppDimens.l),
            if (author != null) ...[
              Text(
                LocaleKeys.article_articleBy.tr(args: [author]),
                style: AppTypography.systemText,
              ),
              const SizedBox(height: AppDimens.xxl),
            ],
            DottedArticleInfo(
              article: article,
              isLight: false,
              showDate: false,
              showReadTime: false,
            ),
            const SizedBox(height: AppDimens.l),
            Text(
              article.title,
              style: AppTypography.h1Bold,
            ),
            const SizedBox(height: AppDimens.m),
            DottedArticleInfo(
              article: article,
              isLight: false,
              showPublisher: false,
              fullDate: true,
            ),
            const SizedBox(height: AppDimens.xl),
          ],
        ),
      ),
    );
  }
}
