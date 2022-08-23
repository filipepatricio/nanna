import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/audio/control_button/audio_control_button_cubit.di.dart';
import 'package:better_informed_mobile/presentation/widget/audio/control_button/audio_control_button_state.dt.dart';
import 'package:better_informed_mobile/presentation/widget/audio/control_button/audio_control_button_state_ext.dart';
import 'package:better_informed_mobile/presentation/widget/audio/control_button/current_audio_floating_progress.dart';
import 'package:better_informed_mobile/presentation/widget/audio/switch_audio/switch_audio_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AudioFloatingControlButton extends HookWidget {
  const AudioFloatingControlButton({
    required this.article,
    this.progressSize = AppDimens.c,
    this.elevation = 0,
    this.imageHeight = AppDimens.sl + AppDimens.xxs,
    this.color = AppColors.background,
    Key? key,
  }) : super(key: key);

  const AudioFloatingControlButton.forCurrentAudio({
    required this.progressSize,
    this.elevation,
    this.imageHeight = AppDimens.m + AppDimens.xxs,
    this.color = AppColors.background,
    Key? key,
  })  : article = null,
        super(key: key);

  final MediaItemArticle? article;
  final double? elevation;
  final double? imageHeight;
  final double progressSize;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final imageUrl = useArticleImageUrl(
      article,
      AppDimens.articleAudioCoverSize,
      AppDimens.articleAudioCoverSize,
    );

    final cubit = useCubitFactory<AudioControlButtonCubit, AudioControlButtonCubitFactory>(
      onCubitCreate: (factory) {
        factory.configure(article: article, imageUrl: imageUrl);
      },
      keys: [article],
    );
    final state = useCubitBuilder(cubit);

    useCubitListener<AudioControlButtonCubit, AudioControlButtonState>(
      cubit,
      (cubit, state, context) {
        state.mapOrNull(
          showSwitchAudioPopup: (_) async {
            final shouldSwitch = await showSwitchAudioPopup(context);
            if (shouldSwitch) {
              await cubit.play(true);
            }
          },
        );
      },
    );

    useEffect(
      () {
        cubit.initialize();
      },
      [cubit, article],
    );

    return FloatingActionButton(
      heroTag: null,
      elevation: elevation,
      highlightElevation: elevation,
      shape: article == null
          ? RoundedRectangleBorder(
              side: const BorderSide(color: AppColors.grey),
              borderRadius: BorderRadius.circular(AppDimens.xl),
            )
          : null,
      onPressed: state.getAction(cubit),
      backgroundColor: color,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(
                left: state.imagePath.contains('play') ? AppDimens.xxs : AppDimens.zero,
              ),
              child: SvgPicture.asset(
                state.imagePath,
                height: imageHeight,
                color: state.imageColor,
              ),
            ),
          ),
          if (article != null)
            CurrentAudioFloatingProgress(
              progressSize,
              state.progress,
              state.audioType,
            ),
        ],
      ),
    );
  }
}
