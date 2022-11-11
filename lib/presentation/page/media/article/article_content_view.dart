import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:better_informed_mobile/domain/article/data/article_content_type.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/media/article/article_image.dart';
import 'package:better_informed_mobile/presentation/page/media/article/paywall/article_paywall_view.dart';
import 'package:better_informed_mobile/presentation/page/media/content/article_content_html.dart';
import 'package:better_informed_mobile/presentation/page/media/content/article_content_markdown.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/in_app_browser.dart';
import 'package:better_informed_mobile/presentation/widget/article/article_dotted_info.dart';
import 'package:better_informed_mobile/presentation/widget/audio/control_button/audio_floating_control_button.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/share/quote/quote_editor_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ArticleContentView extends HookWidget {
  const ArticleContentView({
    required this.article,
    required this.articleContentKey,
    required this.articleHeaderKey,
    Key? key,
  }) : super(key: key);

  final Article article;
  final Key articleHeaderKey;
  final Key articleContentKey;

  @override
  Widget build(BuildContext context) {
    final showCredits = useMemoized(
      () => article.metadata.credits.isNotEmpty && article.metadata.availableInSubscription,
      [article],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ArticleHeader(
          key: articleHeaderKey,
          article: article.metadata,
        ),
        const SizedBox(height: AppDimens.l),
        Column(
          key: articleContentKey,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (article.content.type == ArticleContentType.markdown)
              ArticlePaywallView(
                article: article,
                child: ArticleContentMarkdown(
                  markdown: article.content.content,
                  shareTextCallback: (quote) {
                    showQuoteEditor(
                      context,
                      article.metadata,
                      quote,
                    );
                  },
                ),
              )
            else if (article.content.type == ArticleContentType.html)
              ArticleContentHtml(
                html: article.content.content,
              ),
            if (showCredits)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.m),
                child: _Credits(credits: article.metadata.credits),
              ),
            const SizedBox(height: AppDimens.xxc),
          ],
        ),
      ],
    );
  }
}

class _ArticleHeader extends StatelessWidget {
  const _ArticleHeader({
    required this.article,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;

  @override
  Widget build(BuildContext context) {
    final articleImage = article.image;

    final author = article.author;
    final metadataStyle = AppTypography.systemText.copyWith(height: 1.5);
    final articleColor = article.category.color ?? AppColors.background;

    return Container(
      color: article.hasImage ? articleColor : AppColors.background,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // To extend body behind AppBar without obscuring content
          SizedBox(height: AppDimens.articlePageContentTopPadding(context)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.pageHorizontalMargin),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppDimens.l),
                ArticleDottedInfo(
                  article: article,
                  isLight: false,
                  showDate: false,
                  showReadTime: false,
                  textStyle: AppTypography.metadata1Medium,
                ),
                const SizedBox(height: AppDimens.m),
                InformedMarkdownBody(
                  markdown: article.title,
                  baseTextStyle: AppTypography.articleH0SemiBold,
                  highlightColor: AppColors.transparent,
                ),
                const SizedBox(height: AppDimens.xl),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (author != null) ...[
                            Text(
                              LocaleKeys.article_byName.tr(args: [author]),
                              style: metadataStyle,
                            ),
                            const SizedBox(height: AppDimens.xs),
                          ],
                          ArticleDottedInfo(
                            article: article,
                            isLight: false,
                            showPublisher: false,
                            showLogo: false,
                            textStyle: metadataStyle,
                            publisherMaxLines: 2,
                          ),
                        ],
                      ),
                    ),
                    if (article.hasAudioVersion)
                      SizedBox(
                        height: AppDimens.xxl,
                        child: AudioFloatingControlButton(
                          article: article,
                          elevation: 0,
                          color: AppColors.black,
                          mode: AudioFloatingControlButtonMode.white,
                          imageHeight: AppDimens.xl,
                          progressSize: AppDimens.zero,
                        ),
                      )
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimens.xl),
          if (articleImage != null)
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                height: AppDimens.articleHeaderImageHeight(context),
                width: AppDimens.articleHeaderImageWidth(context),
                child: ArticleImage(
                  image: articleImage,
                  cardColor: AppColors.background,
                  fit: BoxFit.cover,
                ),
              ),
            )
        ],
      ),
    );
  }
}

class _Credits extends StatelessWidget {
  const _Credits({
    required this.credits,
    Key? key,
  }) : super(key: key);

  final String credits;

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: credits,
      styleSheet: MarkdownStyleSheet(
        p: AppTypography.articleTextRegular.copyWith(
          color: AppColors.textGrey,
          fontStyle: FontStyle.italic,
        ),
      ),
      onTapLink: (text, href, title) {
        if (href != null) {
          openInAppBrowser(href);
        }
      },
    );
  }
}
