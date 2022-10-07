import 'dart:math';

import 'package:better_informed_mobile/domain/article/data/article.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/premium_article_audio_cubit.di.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/article/article_dotted_info.dart';
import 'package:better_informed_mobile/presentation/widget/article_cover/article_cover.dart';
import 'package:better_informed_mobile/presentation/widget/audio/control_button/audio_control_button.dart';
import 'package:better_informed_mobile/presentation/widget/audio/progress_bar/audio_progress_bar.dart';
import 'package:better_informed_mobile/presentation/widget/audio/seek_button/audio_seek_button.dart';
import 'package:better_informed_mobile/presentation/widget/audio/speed_button/audio_speed_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:upgrader/upgrader.dart';

class PremiumArticleAudioView extends HookWidget {
  const PremiumArticleAudioView({
    required this.article,
    required this.cubit,
    required this.enablePageSwipe,
    Key? key,
  }) : super(key: key);

  final Article article;
  final PremiumArticleAudioCubit cubit;
  final VoidBoolCallback enablePageSwipe;

  bool get hasAudioCredits => article.audioFile?.credits?.isNotEmpty ?? false;

  @override
  Widget build(BuildContext context) {
    useAutomaticKeepAlive(wantKeepAlive: true);
    useEffect(
      () {
        cubit.preload();
      },
      [cubit],
    );

    final metadataStyle = AppTypography.systemText.copyWith(
      color: AppColors.textGrey,
      height: 1.12,
    );

    return WillPopScope(
      onWillPop: () async => !Navigator.of(context).userGestureInProgress,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
        color: AppColors.background,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: AppDimens.appBarHeight + MediaQuery.of(context).padding.top),
            if (article.hasImage)
              Flexible(
                flex: 15,
                child: AspectRatio(
                  aspectRatio: 0.65,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return ArticleCover.audioView(
                        article: article.metadata,
                        coverColor: AppColors.mockedColors[Random().nextInt(AppColors.mockedColors.length)],
                        height: constraints.maxHeight,
                        width: constraints.maxWidth,
                        shouldShowTimeToRead: false,
                        shouldShowAudioIcon: false,
                      );
                    },
                  ),
                ),
              ),
            const Spacer(),
            Text(
              article.metadata.strippedTitle,
              textAlign: TextAlign.center,
              style: AppTypography.h4Bold,
            ),
            const Spacer(),
            ArticleDottedInfo(
              article: article.metadata,
              isLight: false,
              showLogo: false,
              showReadTime: false,
              fullDate: true,
              textStyle: metadataStyle,
              color: metadataStyle.color,
              centerContent: true,
            ),
            const Spacer(),
            if (hasAudioCredits) ...[
              Text(
                article.audioFile!.credits!,
                textAlign: TextAlign.center,
                style: metadataStyle.copyWith(
                  height: 1.6,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const Spacer(),
            ],
            Expanded(
              flex: 2,
              child: AudioProgressBar(
                article: article.metadata,
                enablePageSwipe: enablePageSwipe,
              ),
            ),
            const Spacer(),
            _AudioComponentsView(article: article.metadata),
            const Spacer(flex: 2),
            const Center(
              child: AudioSpeedButton(),
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}

class _AudioComponentsView extends StatelessWidget {
  const _AudioComponentsView({
    required this.article,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AudioSeekButton.rewind(),
            const SizedBox(width: AppDimens.m),
            AudioControlButton(article: article),
            const SizedBox(width: AppDimens.m),
            AudioSeekButton.fastForward(),
          ],
        )
      ],
    );
  }
}
