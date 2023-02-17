import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/presentation/routing/main_router.gr.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/snackbar_util.dart';
import 'package:better_informed_mobile/presentation/widget/audio/control_button/audio_control_button_cubit.di.dart';
import 'package:better_informed_mobile/presentation/widget/audio/control_button/audio_control_button_state.dt.dart';
import 'package:better_informed_mobile/presentation/widget/audio/control_button/audio_control_button_state_ext.dart';
import 'package:better_informed_mobile/presentation/widget/audio/control_button/current_audio_floating_progress.dart';
import 'package:better_informed_mobile/presentation/widget/audio/switch_audio/switch_audio_popup.dart';
import 'package:better_informed_mobile/presentation/widget/informed_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

enum AudioControlButtonMode { white, colored }

class AudioControlButton extends HookWidget {
  const AudioControlButton({
    required this.article,
    this.progressSize = AppDimens.c,
    this.elevation = 0,
    this.imageHeight = AppDimens.sl + AppDimens.xxs,
    this.backgroundColor,
    this.mode = AudioControlButtonMode.colored,
    this.progressBarColor,
    this.showProgress = true,
    this.dimension,
    super.key,
  }) : iconColor = null;

  const AudioControlButton.forCurrentAudio({
    required this.progressSize,
    this.elevation,
    this.imageHeight = AppDimens.audioViewControlButtonSize * 0.7,
    this.backgroundColor,
    this.mode = AudioControlButtonMode.colored,
    this.progressBarColor,
    this.showProgress = true,
    super.key,
  })  : article = null,
        iconColor = null,
        dimension = null;

  const AudioControlButton.audioPage({
    this.iconColor,
    this.backgroundColor,
    super.key,
  })  : showProgress = false,
        elevation = 0,
        imageHeight = AppDimens.audioViewControlButtonSize * 0.7,
        mode = AudioControlButtonMode.white,
        progressBarColor = backgroundColor,
        article = null,
        progressSize = AppDimens.audioViewControlButtonSize,
        dimension = AppDimens.audioViewControlButtonSize;

  final MediaItemArticle? article;
  final double? elevation;
  final double? imageHeight;
  final double progressSize;
  final Color? iconColor;
  final Color? backgroundColor;
  final AudioControlButtonMode mode;
  final Color? progressBarColor;
  final bool showProgress;
  final double? dimension;

  @override
  Widget build(BuildContext context) {
    final snackbarController = useSnackbarController();
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
          needsSubscription: (_) async {
            await context.pushRoute(const SubscriptionPageRoute());
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

    return Opacity(
      opacity: state.maybeMap(offline: (_) => AppDimens.offlineIconOpacity, orElse: () => 1),
      child: SizedBox.square(
        dimension: dimension,
        child: FloatingActionButton(
          heroTag: null,
          elevation: elevation,
          highlightElevation: elevation,
          shape: article == null
              ? RoundedRectangleBorder(
                  side: BorderSide(
                    color: mode == AudioControlButtonMode.colored
                        ? AppColors.of(context).backgroundSecondary
                        : AppColors.of(context).blackWhiteSecondary,
                  ),
                  borderRadius: BorderRadius.circular(AppDimens.xl),
                )
              : null,
          onPressed: state.getAction(context, cubit, snackbarController),
          backgroundColor: (backgroundColor ?? AppColors.of(context).backgroundSecondary).withAlpha(state.imageAlpha),
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: state.imagePath.contains('play') ? AppDimens.xxs : AppDimens.zero,
                  ),
                  child: InformedSvg(
                    state.imagePath,
                    height: imageHeight,
                    color: iconColor ??
                        (mode == AudioControlButtonMode.colored
                            ? AppColors.of(context).iconPrimary.withAlpha(state.imageAlpha)
                            : AppColors.stateTextSecondary),
                  ),
                ),
              ),
              if (article != null)
                CurrentAudioFloatingProgress(
                  progressSize: progressSize,
                  progress: state.progress,
                  audioProgressType: state.audioProgressType,
                  progressBarColor: progressBarColor ?? AppColors.of(context).textPrimary,
                  showProgress: showProgress,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
