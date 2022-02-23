import 'dart:async';

import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/share/base_share_completable.dart';
import 'package:better_informed_mobile/presentation/widget/share/image_load_resolver.dart';
import 'package:better_informed_mobile/presentation/widget/share/quote/quote_variant_data.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

const _cardWidth = 480.0;
const _cardRadius = 24.0;
const _logoHeight = 24.0;

class QuoteView extends HookWidget implements BaseShareCompletable {
  QuoteView({
    required this.quote,
    required this.article,
    required this.quoteVariantData,
    Key? key,
  })  : _completer = Completer(),
        super(key: key);

  final String quote;
  final MediaItemArticle article;
  final QuoteVariantData quoteVariantData;
  final Completer _completer;

  @override
  Size get size => const Size(720, 1280);

  @override
  Completer get viewReadyCompleter => _completer;

  @override
  Widget build(BuildContext context) {
    final cloudinary = useCloudinaryProvider();
    final articleImageId = article.image?.publicId;

    final articleImage = useMemoized(
      () {
        if (articleImageId == null) return null;

        final imageUrl = cloudinary
            .withPublicId(articleImageId)
            .transform()
            .width(110)
            .height(110)
            .autoGravity()
            .autoQuality()
            .generateNotNull();

        return Image.network(
          imageUrl,
          width: 110,
          height: 110,
          fit: BoxFit.fill,
        );
      },
    );

    return ImageLoadResolver(
      images: [articleImage],
      completer: viewReadyCompleter,
      child: Material(
        color: AppColors.background,
        child: Container(
          width: size.width,
          height: size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _Quote(
                  quote: quote,
                  quoteVariantData: quoteVariantData,
                  article: article,
                ),
              ),
              const SizedBox(height: AppDimens.xl),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.xxxl),
                child: _ArticleBanner(
                  article: article,
                  image: articleImage,
                ),
              ),
              const SizedBox(height: AppDimens.xxxl),
            ],
          ),
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
    return Center(
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
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.2),
              offset: const Offset(0.0, 6.0),
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
            _Author(
              article: article,
              style: AppTypography.h2Jakarta.copyWith(
                fontSize: 21,
                color: quoteVariantData.foregroundColor,
              ),
            ),
            const SizedBox(height: AppDimens.s),
            Text(
              tr(LocaleKeys.shareQuote_title, args: [article.strippedTitle]),
              style: AppTypography.h2Jakarta.copyWith(
                fontSize: 21,
                color: quoteVariantData.foregroundColor,
              ),
              maxLines: 2,
            ),
          ],
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
        baseTextStyle: AppTypography.h0SemiBold.copyWith(
          color: quoteVariantData.foregroundColor,
          fontFamily: fontFamilyLora,
        ),
      );
    } else {
      return Text(
        '‘$quote’',
        style: AppTypography.h0SemiBold.copyWith(
          color: quoteVariantData.foregroundColor,
          fontFamily: fontFamilyLora,
        ),
      );
    }
  }
}

class _ArticleBanner extends StatelessWidget {
  const _ArticleBanner({
    required this.article,
    required this.image,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;
  final Image? image;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              tr(LocaleKeys.shareQuote_readOn),
              style: AppTypography.h1.copyWith(height: 1.0),
            ),
            SvgPicture.asset(
              AppVectorGraphics.informedLogoDark,
              height: _logoHeight,
            ),
          ],
        ),
        const SizedBox(height: AppDimens.xl),
        Row(
          children: [
            if (image != null) ...[
              ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(_cardRadius),
                ),
                child: image!,
              ),
              const SizedBox(width: AppDimens.l),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.strippedTitle,
                    style: AppTypography.h1HeadlineBig,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppDimens.s),
                  _Author(
                    article: article,
                    style: AppTypography.h2Jakarta,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Author extends StatelessWidget {
  const _Author({
    required this.article,
    required this.style,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    if (article.author == null) {
      return Text(
        '${article.publisher.name}',
        style: style,
        maxLines: 1,
      );
    } else {
      return Text(
        '${article.publisher.name} · By ${article.author}',
        style: style,
        maxLines: 1,
      );
    }
  }
}
