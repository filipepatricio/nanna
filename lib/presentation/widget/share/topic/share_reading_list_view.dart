import 'dart:async';
import 'dart:math';

import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/widget/share/base_share_completable.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
  Completer get viewReadyCompleter => _baseViewCompleter;

  @override
  Widget build(BuildContext context) {
    final cloudinary = useCloudinaryProvider();
    final imageUrl = useMemoized(
      () {
        return cloudinary
            .withPublicId(topic.heroImage.publicId)
            .transform()
            .width(_topicHeaderImageWidth.toInt())
            .height(_topicHeaderImageHeight.toInt())
            .autoGravity()
            .autoQuality()
            .generateNotNull();
      },
    );
    final image = useMemoized(
      () => Image.network(
        imageUrl,
        width: _topicHeaderImageWidth,
        height: _topicHeaderImageHeight,
        fit: BoxFit.fill,
      ),
    );

    useEffect(
      () {
        final stream = image.image.resolve(ImageConfiguration.empty);
        final imageStreamListener = ImageStreamListener(
          (info, syncCall) => _baseViewCompleter.complete(),
          onError: (info, syncCall) => _baseViewCompleter.completeError(info),
        );
        stream.addListener(imageStreamListener);
        return () => stream.removeListener(imageStreamListener);
      },
      [image],
    );

    return _Background(
      child: _Sticker(
        topic: topic,
        articles: articles,
        image: image,
      ),
    );
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
        color: AppColors.pastelGreen,
        child: Stack(
          children: [
            ..._topCards(),
            ..._centerCards(),
            ..._leftCards(),
            ..._rightCards(),
            ..._bottomCards(),
            Positioned(
              right: 54,
              bottom: 50,
              child: SvgPicture.asset(
                AppVectorGraphics.informedLogoDark,
                width: 194.0,
                height: 40,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: child,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _topCards() => [
        const Positioned(
          top: -498,
          left: -128,
          child: _EmptyCard(
            height: 562,
            width: 512,
            rotation: -4,
          ),
        ),
      ];

  List<Widget> _centerCards() => [
        const Positioned(
          top: 286.78,
          left: 151.46,
          child: _EmptyCard(
            height: 596.56,
            width: 412.23,
            rotation: -8.83,
          ),
        ),
        const Positioned(
          top: 261.41,
          left: 152.51,
          child: _EmptyCard(
            height: 706.45,
            width: 464.04,
            rotation: -4.76,
          ),
        ),
      ];

  List<Widget> _leftCards() => [
        const Positioned(
          top: 860.7,
          left: -444.27,
          child: _EmptyCard(
            height: 342.06,
            width: 498.84,
            rotation: -4,
          ),
        ),
        const Positioned(
          top: 354.98,
          left: -394.27,
          child: _EmptyCard(
            height: 774.7,
            width: 503.13,
            rotation: -9.85,
          ),
        ),
      ];

  List<Widget> _rightCards() => [
        const Positioned(
          top: 87.61,
          left: 715.89,
          child: _EmptyCard(
            height: 470.69,
            width: 346.72,
            rotation: -13.1,
          ),
        ),
        const Positioned(
          top: 82.5,
          left: 694.68,
          child: _EmptyCard(
            height: 638.4,
            width: 321.3,
            rotation: -4,
          ),
        ),
      ];

  List<Widget> _bottomCards() => [
        const Positioned(
          top: 1089.27,
          left: 377,
          child: _EmptyCard(
            height: 562.37,
            width: 450.22,
            rotation: -8.26,
          ),
        ),
        const Positioned(
          top: 1059.41,
          left: 391.99,
          child: _EmptyCard(
            height: 562.37,
            width: 450.22,
            rotation: -4,
          ),
        ),
      ];
}

class _Sticker extends StatelessWidget {
  final Topic topic;
  final List<MediaItemArticle> articles;
  final Image image;

  const _Sticker({
    required this.topic,
    required this.articles,
    required this.image,
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
          ),
          const SizedBox(height: AppDimens.xl),
          Padding(
            padding: const EdgeInsets.only(left: 22),
            child: _ArticleRow(articles: articles),
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

  const _TopicHeader({
    required this.topic,
    required this.image,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        image,
        Positioned.fill(
          child: Container(
            color: AppColors.black.withOpacity(0.4),
          ),
        ),
        Positioned(
          left: AppDimens.xl,
          top: AppDimens.xl,
          child: _Author(
            topic: topic,
          ),
        ),
        Positioned(
          top: AppDimens.xxc,
          left: AppDimens.xl,
          right: AppDimens.xl,
          bottom: AppDimens.xl,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              topic.title,
              style: _topicTitleStyle,
            ),
          ),
        ),
      ],
    );
  }
}

class _Author extends StatelessWidget {
  final Topic topic;

  const _Author({
    required this.topic,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: use data that will be coming from API
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: const BoxDecoration(
            color: AppColors.rose,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: AppDimens.s),
        Text(
          'By Editorial Team',
          style: AppTypography.h3boldLoraItalic.copyWith(color: AppColors.white),
        ),
      ],
    );
  }
}

class _ArticleRow extends StatelessWidget {
  final List<MediaItemArticle> articles;

  const _ArticleRow({
    required this.articles,
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

      yield _ArticleItem(article: article, backgroundColor: color);
    }
  }
}

class _ArticleItem extends HookWidget {
  final MediaItemArticle article;
  final Color backgroundColor;

  const _ArticleItem({
    required this.article,
    required this.backgroundColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cloudinary = useCloudinaryProvider();
    final logoId = article.publisher.darkLogo?.publicId;

    return Container(
      width: 140,
      height: 210,
      padding: const EdgeInsets.all(AppDimens.m),
      color: backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (logoId != null)
            Align(
              alignment: Alignment.centerLeft,
              child: Image.network(
                cloudinary
                    .withPublicIdAsPng(logoId)
                    .transform()
                    .width(_publisherLogoSize.toInt())
                    .height(_publisherLogoSize.toInt())
                    .fit()
                    .generateNotNull(),
                width: _publisherLogoSize,
                height: _publisherLogoSize,
              ),
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
          const SizedBox(height: AppDimens.s),
          Text(
            tr(
              LocaleKeys.article_readMinutes,
              args: [article.timeToRead.toString()],
            ),
            style: AppTypography.systemText,
          ),
        ],
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  final double width;
  final double height;
  final double rotation;

  const _EmptyCard({
    required this.width,
    required this.height,
    required this.rotation,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final angle = rotation * pi / 180;

    return Transform.rotate(
      angle: angle,
      origin: Offset(width / 2, height / 2),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.background,
          boxShadow: [_cardShadow],
        ),
      ),
    );
  }
}
