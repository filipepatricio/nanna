import 'dart:math';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/presentation/page/explore/article_with_cover_area/article_list_item.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/article/covers/dotted_article_info.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/device_type.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/bordered_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

const _barHeight = 3.0;
const _thumbRadius = 6.0;
const _thumbGlowRadius = 15.0;

class PremiumArticleAudioView extends HookWidget {
  const PremiumArticleAudioView({
    required this.article,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;

  @override
  Widget build(BuildContext context) {
    const audioTotalSeconds = 120;
    final audioProgress = useMemoized(() => ValueNotifier(0));
    final isPlaying = useMemoized(() => ValueNotifier(false));

    final metadataStyle = AppTypography.systemText.copyWith(color: AppColors.textGrey, height: 1.12);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
      color: AppColors.background,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: AppDimens.appBarHeight + AppDimens.m),
          if (context.isNotSmallDevice || article.image != null) ...[
            Flexible(
              flex: 9,
              child: AspectRatio(
                aspectRatio: context.isNotSmallDevice ? 0.65 : 1,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return ArticleListItem(
                      article: article,
                      themeColor: AppColors.background,
                      cardColor: AppColors.mockedColors[Random().nextInt(AppColors.mockedColors.length)],
                      height: constraints.maxHeight,
                      width: constraints.maxWidth,
                      shouldShowTextOverlay: context.isNotSmallDevice,
                      shouldShowAudioIcon: false,
                    );
                  },
                ),
              ),
            ),
          ],
          const Spacer(),
          Text(
            article.strippedTitle,
            textAlign: TextAlign.center,
            style: AppTypography.h4Bold,
          ),
          const Spacer(),
          DottedArticleInfo(
            article: article,
            isLight: false,
            showLogo: false,
            fullDate: context.isNotSmallDevice,
            textStyle: metadataStyle,
            color: metadataStyle.color,
          ),
          const Spacer(),
          Expanded(
            flex: 2,
            child: ValueListenableBuilder(
              valueListenable: audioProgress,
              builder: (BuildContext context, int value, Widget? child) {
                return ProgressBar(
                  progress: Duration(seconds: value),
                  total: const Duration(seconds: audioTotalSeconds),
                  progressBarColor: AppColors.textPrimary,
                  baseBarColor: AppColors.grey,
                  bufferedBarColor: AppColors.transparent,
                  thumbColor: AppColors.textPrimary,
                  barHeight: _barHeight,
                  thumbRadius: _thumbRadius,
                  thumbGlowRadius: _thumbGlowRadius,
                  timeLabelLocation: TimeLabelLocation.sides,
                  timeLabelTextStyle: AppTypography.timeLabelText,
                  onDragUpdate: (details) {
                    audioProgress.value = details.timeStamp.inSeconds;
                  },
                  onSeek: (duration) {
                    //TODO: Advance audio to duration
                  },
                );
              },
            ),
          ),
          const Spacer(),
          _AudioComponentsView(
            article: article,
            isPlaying: isPlaying,
          ),
          const Spacer(flex: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BorderedButton(
                text: Text(
                  'Speed 1.0x',
                  style: AppTypography.h5BoldSmall.copyWith(height: 1.2),
                ),
                onTap: () {},
              ),
            ],
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}

class _AudioComponentsView extends StatelessWidget {
  const _AudioComponentsView({
    required this.article,
    required this.isPlaying,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;
  final ValueNotifier<bool> isPlaying;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            const Spacer(flex: 5),
            IconButton(
              onPressed: () {},
              padding: const EdgeInsets.only(right: AppDimens.s),
              icon: SvgPicture.asset(
                AppVectorGraphics.skip_back_10_seconds,
                color: AppColors.textPrimary,
              ),
            ),
            const Spacer(),
            ValueListenableBuilder(
              valueListenable: isPlaying,
              builder: (BuildContext context, bool value, Widget? child) {
                return IconButton(
                  onPressed: () {
                    isPlaying.value = !value;
                  },
                  padding: const EdgeInsets.only(right: AppDimens.s),
                  icon: SvgPicture.asset(
                    value ? AppVectorGraphics.pause : AppVectorGraphics.play_arrow,
                    color: AppColors.textPrimary,
                  ),
                );
              },
            ),
            const Spacer(),
            IconButton(
              onPressed: () {},
              padding: const EdgeInsets.only(right: AppDimens.s),
              icon: SvgPicture.asset(
                AppVectorGraphics.skip_forward_10_seconds,
                color: AppColors.textPrimary,
              ),
            ),
            const Spacer(flex: 5),
          ],
        )
      ],
    );
  }
}
