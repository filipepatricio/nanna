import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/presentation/page/media/article/article_image.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/article/article_dotted_info.dart';
import 'package:better_informed_mobile/presentation/widget/audio_icon.dart';
import 'package:better_informed_mobile/presentation/widget/cover_label/cover_label.dart';
import 'package:better_informed_mobile/presentation/widget/publisher_logo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const _coverSizeToScreenWidthFactor = 0.30;

class ArticleCoverDailyBriefListItem extends HookWidget {
  const ArticleCoverDailyBriefListItem({
    required this.onTap,
    required this.article,
    required this.coverColor,
    Key? key,
  }) : super(key: key);

  final VoidCallback? onTap;
  final MediaItemArticle article;
  final Color? coverColor;

  @override
  Widget build(BuildContext context) {
    final coverSize = useMemoized(
      () => MediaQuery.of(context).size.width * _coverSizeToScreenWidthFactor,
      [MediaQuery.of(context).size],
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        children: [
          SizedBox.square(
            dimension: coverSize,
            child: _CoverImage(
              article: article,
              coverColor: coverColor,
              showArticleIndicator: false,
            ),
          ),
          const SizedBox(width: AppDimens.m),
          Expanded(
            child: SizedBox(
              height: coverSize,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    children: [
                      PublisherLogo.dark(publisher: article.publisher),
                      Flexible(
                        child: Text(
                          article.publisher.name,
                          maxLines: 1,
                          style: AppTypography.caption1Medium.copyWith(color: AppColors.textGrey),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    article.strippedTitle,
                    maxLines: 2,
                    style: AppTypography.h5BoldSmall.copyWith(height: 1.25),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Flexible(
                    child: ArticleDottedInfo(
                      article: article,
                      isLight: false,
                      showLogo: false,
                      showPublisher: false,
                      showDate: false,
                      textStyle: AppTypography.caption1Medium,
                      color: AppColors.textGrey,
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

class _CoverImage extends StatelessWidget {
  const _CoverImage({
    required this.article,
    required this.coverColor,
    required this.showArticleIndicator,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;
  final Color? coverColor;
  final bool showArticleIndicator;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppDimens.s),
            child: article.hasImage
                ? ArticleImage(
                    image: article.image!,
                    cardColor: coverColor,
                  )
                : SizedBox.expand(
                    child: Container(color: coverColor),
                  ),
          ),
        ),
        if (showArticleIndicator)
          Positioned(
            top: AppDimens.s,
            left: AppDimens.s,
            child: CoverLabel.article(),
          ),
        if (article.hasAudioVersion)
          Positioned(
            bottom: AppDimens.s,
            right: AppDimens.s,
            child: AudioIconButton(article: article),
          ),
      ],
    );
  }
}
