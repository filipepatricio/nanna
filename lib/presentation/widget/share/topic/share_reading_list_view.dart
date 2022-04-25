import 'dart:async';

import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
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
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const _cardShadow = BoxShadow(
  color: AppColors.shadowColor,
  offset: Offset(0.0, 4.0),
  blurRadius: 2.0,
  spreadRadius: -1.0,
);

const _viewHeight = 1280.0;
const _viewWidth = 720.0;

const _topicHeaderHeight = 878.0;
const _topicHeaderWidth = 520.0;

const _topicHeaderImageHeight = 587.0;
const _topicHeaderImageWidth = 520.0;

const _publisherLogoSize = 28.0;

const _articleItemWidth = 152.0;
const _articleItemHeight = 227.0;

const _articleListPadding = 20.0;

class ShareReadingListView extends HookWidget implements BaseShareCompletable {
  ShareReadingListView({
    required this.topic,
    required this.articles,
    Key? key,
  })  : _baseViewCompleter = Completer(),
        super(key: key);

  final Topic topic;
  final List<MediaItemArticle> articles;
  final Completer _baseViewCompleter;

  @override
  Size get size => const Size(_viewWidth, _viewHeight);

  @override
  Completer get viewReadyCompleter => _baseViewCompleter;

  @override
  Widget build(BuildContext context) {
    final cloudinary = useCloudinaryProvider();
    final image = useMemoized(
      () {
        return cloudinaryImageAuto(
          cloudinary: cloudinary,
          publicId: topic.heroImage.publicId,
          width: _topicHeaderImageWidth,
          height: _topicHeaderImageHeight,
          fit: BoxFit.cover,
          testImage: AppRasterGraphics.testArticleHeroImage,
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
      final image = cloudinaryImageFit(
        cloudinary: cloudinary,
        publicId: article.publisher.darkLogo!.publicId,
        width: _publisherLogoSize,
        height: _publisherLogoSize,
        fit: BoxFit.fill,
        testImage: AppRasterGraphics.testPublisherLogoDark,
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
      child: SizedBox(
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
      decoration: const BoxDecoration(
        color: AppColors.background,
        boxShadow: [_cardShadow],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: _TopicHeader(
              topic: topic,
              image: image,
              articlesLength: articles.length,
            ),
          ),
          Positioned(
            bottom: AppDimens.xl,
            left: _articleListPadding,
            right: _articleListPadding,
            child: _ArticleRow(
              articles: articles,
              articleLogos: articleLogos,
            ),
          ),
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
          Positioned.fill(
            child: Container(color: AppColors.black40),
          ),
          Positioned(
            top: AppDimens.xxl,
            left: AppDimens.xl,
            right: AppDimens.xl,
            child: TopicOwnerAvatar(
              withPrefix: true,
              owner: topic.owner,
              mode: Brightness.light,
            ),
          ),
          Positioned(
            bottom: AppDimens.xl,
            left: AppDimens.xl,
            right: AppDimens.xl,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  InformedMarkdownBody(
                    markdown: topic.title,
                    baseTextStyle: AppTypography.h0Bold.copyWith(
                      color: AppColors.white,
                      height: 1.25,
                    ),
                    maxLines: 6,
                  ),
                  const SizedBox(height: AppDimens.xl),
                  Text(
                    LocaleKeys.todaysTopics_selectedArticles.tr(args: ['$articlesLength']),
                    style: AppTypography.b2Regular.copyWith(color: AppColors.white, height: 1),
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _generateRow(),
    );
  }

  List<Widget> _generateRow() {
    return _createArticleWidgets(articles).toList();
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
      child: Stack(
        children: [
          Column(
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
                child: InformedMarkdownBody(
                  markdown: article.title,
                  baseTextStyle: AppTypography.h5BoldSmall.copyWith(height: 1.15),
                  maxLines: 5,
                  highlightColor: AppColors.transparent,
                ),
              ),
            ],
          ),
          if (timeToRead != null) ...[
            Positioned(
              bottom: 0,
              left: 0,
              child: Text(
                tr(
                  LocaleKeys.article_readMinutes,
                  args: [article.timeToRead.toString()],
                ),
                style: AppTypography.systemText,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
