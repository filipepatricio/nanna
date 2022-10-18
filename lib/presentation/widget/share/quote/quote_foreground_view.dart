import 'dart:async';

import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/share/base_share_completable.dart';
import 'package:better_informed_mobile/presentation/widget/share/quote/quote_author.dart';
import 'package:better_informed_mobile/presentation/widget/share/quote/quote_variant_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';

const _cardWidth = 720 - 2 * AppDimens.xxxl - 2 * _padding;
const _cardHeight = 640.0 - 2 * _padding;
const _padding = 24.0;

class QuoteForegroundView extends HookWidget implements BaseShareCompletable {
  QuoteForegroundView({
    required this.quote,
    required this.article,
    required this.quoteVariantData,
    Key? key,
  }) : super(key: key);

  final String quote;
  final MediaItemArticle article;
  final QuoteVariantData quoteVariantData;
  final Completer _completer = Completer();

  @override
  Size get size => const Size(_cardWidth + _padding * 2, _cardHeight + _padding * 2);

  @override
  Completer get viewReadyCompleter => _completer;

  @override
  Widget build(BuildContext context) {
    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => _completer.complete(),
        );
      },
      [],
    );

    return Material(
      color: AppColors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(_padding),
        child: _Quote(
          article: article,
          quote: quote,
          quoteVariantData: quoteVariantData,
        ),
      ),
    );
  }
}

class _Quote extends StatelessWidget {
  const _Quote({
    required this.quoteVariantData,
    required this.quote,
    required this.article,
    Key? key,
  }) : super(key: key);

  final QuoteVariantData quoteVariantData;
  final String quote;
  final MediaItemArticle article;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _cardHeight,
      child: Center(
        child: Container(
          width: _cardWidth,
          padding: const EdgeInsets.fromLTRB(
            AppDimens.l,
            AppDimens.l,
            AppDimens.l,
            AppDimens.xl,
          ),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(AppDimens.l),
            ),
            boxShadow: const [
              BoxShadow(
                color: AppColors.black20,
                offset: Offset(0.0, 6.0),
                blurRadius: 15,
              ),
            ],
            color: quoteVariantData.backgroundColor,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (quoteVariantData.iconPath != null) ...[
                Align(
                  alignment: Alignment.topLeft,
                  child: SvgPicture.asset(AppVectorGraphics.newspaper),
                ),
                const SizedBox(height: AppDimens.l),
              ],
              _QuoteText(
                quote: quote,
                quoteVariantData: quoteVariantData,
              ),
              const SizedBox(height: AppDimens.xxl),
              QuoteAuthor(
                article: article,
                style: AppTypography.h2Regular.copyWith(
                  fontSize: 21,
                  color: quoteVariantData.foregroundColor,
                ),
              ),
              const SizedBox(height: AppDimens.s),
              Text(
                tr(LocaleKeys.shareQuote_title, args: [article.strippedTitle]),
                style: AppTypography.h2Regular.copyWith(
                  fontSize: 21,
                  color: quoteVariantData.foregroundColor,
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuoteText extends StatelessWidget {
  const _QuoteText({
    required this.quote,
    required this.quoteVariantData,
    Key? key,
  }) : super(key: key);

  final String quote;
  final QuoteVariantData quoteVariantData;

  @override
  Widget build(BuildContext context) {
    if (quoteVariantData.withTextMark) {
      return InformedMarkdownBody(
        markdown: '‘_${quote}_’',
        baseTextStyle: AppTypography.articleQuote.copyWith(
          color: quoteVariantData.foregroundColor,
        ),
      );
    } else {
      return Text(
        '‘$quote’',
        style: AppTypography.articleQuote.copyWith(
          color: quoteVariantData.foregroundColor,
        ),
      );
    }
  }
}
