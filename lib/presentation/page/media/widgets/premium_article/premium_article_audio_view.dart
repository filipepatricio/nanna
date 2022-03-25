import 'dart:math';

import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/presentation/page/explore/article_with_cover_area/article_list_item.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/audio/fast_forward_button/audio_fast_forward_button.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/audio/progress_bar/audio_progress_bar.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/audio/rewind_button/audio_rewind_button.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/premium_article_audio_view_cubit.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/premium_article_audio_view_state.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/article/covers/dotted_article_info.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/device_type.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/bordered_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

class PremiumArticleAudioView extends HookWidget {
  const PremiumArticleAudioView({
    required this.article,
    required this.cubit,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;
  final PremiumArticleAudioViewCubit cubit;

  @override
  Widget build(BuildContext context) {
    final state = useCubitBuilder(cubit);

    final metadataStyle = AppTypography.systemText.copyWith(
      color: AppColors.textGrey,
      height: 1.12,
    );

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
          const Expanded(
            flex: 2,
            child: AudioProgressProgressBar(),
          ),
          const Spacer(),
          _AudioComponentsView(
            cubit: cubit,
            article: article,
            isPlaying: state.isPlaying,
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
    required this.cubit,
    required this.article,
    required this.isPlaying,
    Key? key,
  }) : super(key: key);

  final PremiumArticleAudioViewCubit cubit;
  final MediaItemArticle article;
  final bool isPlaying;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            const Spacer(flex: 5),
            const AudioRewindButton(),
            const Spacer(),
            IconButton(
              onPressed: isPlaying ? () => cubit.pause() : () => cubit.play(),
              padding: const EdgeInsets.only(right: AppDimens.s),
              icon: SvgPicture.asset(
                isPlaying ? AppVectorGraphics.pause : AppVectorGraphics.play_arrow,
                color: AppColors.textPrimary,
              ),
            ),
            const Spacer(),
            const AudioFastForwardButton(),
            const Spacer(flex: 5),
          ],
        )
      ],
    );
  }
}

extension on PremiumArticleAudioViewState {
  bool get isPlaying {
    return maybeMap(
      playing: (_) => true,
      orElse: () => false,
    );
  }
}
