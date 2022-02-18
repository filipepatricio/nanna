import 'dart:async';

import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/app_raster_graphics.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/share/base_share_completable.dart';
import 'package:better_informed_mobile/presentation/widget/share/image_load_resolver.dart';
import 'package:better_informed_mobile/presentation/widget/topic_owner_avatar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const _topicTitleStyle = TextStyle(
  color: AppColors.white,
  fontSize: 40,
  height: 1.25,
  fontWeight: FontWeight.w700,
  fontFamily: fontFamilyPlusJakartaSans,
);

final _cardShadow = BoxShadow(
  color: AppColors.shadowColor,
  offset: const Offset(0.0, 4.0),
  blurRadius: 2.0,
  spreadRadius: -1.0,
);

const _viewHeight = 1280.0;
const _viewWidth = 720.0;

const _topicHeaderHeight = 640.0;
const _topicHeaderWidth = 480.0;

const _topicHeaderImageHeight = 366.0;
const _topicHeaderImageWidth = 480.0;

const _publisherLogoSize = 28.0;

const _articleItemWidth = 140.0;
const _articleItemHeight = 210.0;

const _articleListPadding = 22.0;

class ShareReadingListView extends HookWidget implements BaseShareCompletable {
  final Topic topic;
  final List<MediaItemArticle> articles;
  final Completer _baseViewCompleter;

  ShareReadingListView({
    required this.topic,
    required this.articles,
    Key? key,
  })  : _baseViewCompleter = Completer(),
        super(key: key);

  @override
  Size get size => const Size(_viewWidth, _viewHeight);

  @override
  Completer get viewReadyCompleter => _baseViewCompleter;

  @override
  Widget build(BuildContext context) {
    final cloudinary = useCloudinaryProvider();
    final image = useMemoized(
      () {
        final imageUrl = cloudinary
            .withPublicId(topic.heroImage.publicId)
            .transform()
            .width(_topicHeaderImageWidth.toInt())
            .height(_topicHeaderImageHeight.toInt())
            .autoGravity()
            .autoQuality()
            .generateNotNull();

        return Image.network(
          imageUrl,
          width: _topicHeaderImageWidth,
          height: _topicHeaderImageHeight,
          fit: BoxFit.fill,
        );
      },
    );

    final logosMap = useMemoized(() => _prepareLogos(cloudinary));

    return ImageLoadResolver(
      images: [image, ...logosMap.values],
      completer: _baseViewCompleter,
      child: _Background(
        child: _Sticker(
          topic: topic,
          articles: articles,
          image: image,
          articleLogos: logosMap,
        ),
      ),
    );
  }

  Map<String, Image> _prepareLogos(CloudinaryImageProvider cloudinary) {
    final entries = articles.where((element) => element.publisher.darkLogo != null).map((article) {
      final image = Image.network(
        cloudinary
            .withPublicIdAsPng(article.publisher.darkLogo!.publicId)
            .transform()
            .width(_publisherLogoSize.toInt())
            .height(_publisherLogoSize.toInt())
            .fit()
            .generateNotNull(),
        width: _publisherLogoSize,
        height: _publisherLogoSize,
      );
      return MapEntry(article.id, image);
    }).toList();

    return Map.fromEntries(entries);
  }
}

class _Background extends StatelessWidget {
  final Widget child;

  const _Background({
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: _viewWidth,
        height: _viewHeight,
        child: Stack(
          children: [
            Image.asset(AppRasterGraphics.shareStickerBackgroundGreen),
            Align(
              alignment: Alignment.center,
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

class _Sticker extends StatelessWidget {
  final Topic topic;
  final List<MediaItemArticle> articles;
  final Image image;
  final Map<String, Image> articleLogos;

  const _Sticker({
    required this.topic,
    required this.articles,
    required this.image,
    required this.articleLogos,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _topicHeaderWidth,
      height: _topicHeaderHeight,
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [_cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _TopicHeader(
            topic: topic,
            image: image,
            articlesLength: articles.length,
          ),
          const SizedBox(height: AppDimens.xl),
          Padding(
            padding: const EdgeInsets.only(left: _articleListPadding),
            child: _ArticleRow(
              articles: articles,
              articleLogos: articleLogos,
            ),
          ),
          const SizedBox(height: AppDimens.xl),
        ],
      ),
    );
  }
}

class _TopicHeader extends StatelessWidget {
  final Topic topic;
  final Image image;
  final int articlesLength;

  const _TopicHeader({
    required this.topic,
    required this.image,
    required this.articlesLength,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _topicHeaderImageWidth,
      height: _topicHeaderImageHeight,
      child: Stack(
        children: [
          image,
          Container(
            color: AppColors.black.withOpacity(0.4),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.xl, vertical: AppDimens.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TopicOwnerAvatar(owner: topic.owner, mode: Brightness.light),
                  const Spacer(),
                  Expanded(
                    child: InformedMarkdownBody(
                      markdown: topic.title,
                      baseTextStyle: _topicTitleStyle,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: AppDimens.xl),
                    child: Text(
                      LocaleKeys.todaysTopics_selectedArticles.tr(args: ['$articlesLength']),
                      style: AppTypography.b1Regular.copyWith(color: AppColors.white, height: 1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ArticleRow extends StatelessWidget {
  final List<MediaItemArticle> articles;
  final Map<String, Image> articleLogos;

  const _ArticleRow({
    required this.articles,
    required this.articleLogos,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _generateRow(),
    );
  }

  List<Widget> _generateRow() {
    return _createArticleWidgets(articles).expand((element) => [element, const SizedBox(width: AppDimens.s)]).toList();
  }

  Iterable<Widget> _createArticleWidgets(List<MediaItemArticle> articles) sync* {
    for (var i = 0; i < articles.length; i++) {
      final article = articles[i];
      final color = AppColors.mockedColors[i % AppColors.mockedColors.length];

      yield _ArticleItem(
        article: article,
        backgroundColor: color,
        logo: articleLogos[article.id],
      );
    }
  }
}

class _ArticleItem extends StatelessWidget {
  final MediaItemArticle article;
  final Color backgroundColor;
  final Image? logo;

  const _ArticleItem({
    required this.article,
    required this.backgroundColor,
    required this.logo,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeToRead = article.timeToRead;

    return Container(
      width: _articleItemWidth,
      height: _articleItemHeight,
      padding: const EdgeInsets.all(AppDimens.m),
      color: backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (logo != null)
            Align(
              alignment: Alignment.centerLeft,
              child: logo,
            )
          else
            const SizedBox(height: _publisherLogoSize),
          const SizedBox(height: AppDimens.m),
          Expanded(
            child: Text(
              article.title,
              style: AppTypography.h5BoldSmall.copyWith(height: 1.15),
              maxLines: 5,
            ),
          ),
          if (timeToRead != null) ...[
            const SizedBox(height: AppDimens.s),
            Text(
              tr(
                LocaleKeys.article_readMinutes,
                args: [article.timeToRead.toString()],
              ),
              style: AppTypography.systemText,
            ),
          ],
        ],
      ),
    );
  }
}
