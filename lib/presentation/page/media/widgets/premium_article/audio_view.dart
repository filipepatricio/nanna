import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/presentation/page/explore/article_with_cover_area/article_list_item.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/article/covers/dotted_article_info.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/bordered_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

const _barHeight = 3.0;
const _thumbRadius = 6.0;
const _thumbGlowRadius = 12.0;

class AudioView extends HookWidget {
  const AudioView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(color: AppColors.background);
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
