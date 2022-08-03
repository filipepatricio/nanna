import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/audio/control_button/audio_control_button_state_ext.dart';
import 'package:better_informed_mobile/presentation/widget/audio/progress_bar/audio_progress_bar_cubit.dart';
import 'package:better_informed_mobile/presentation/widget/audio/progress_bar/audio_progress_bar_cubit_factory.di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CurrentAudioFloatingProgress extends HookWidget {
  const CurrentAudioFloatingProgress(
    this.progressSize,
    this.progress,
    this.audioProgressType, {
    Key? key,
  }) : super(key: key);

  final double progressSize;
  final double progress;
  final AudioProgressType audioProgressType;

  @override
  Widget build(BuildContext context) {
    final cubit = useCubitFactory<AudioProgressBarCubit, AudioProgressBarCubitFactory>(closeOnDispose: false);
    final state = useCubitBuilder(cubit);

    return RepaintBoundary(
      child: SizedBox(
        width: progressSize,
        height: progressSize,
        child: audioProgressType == AudioProgressType.loading
            ? CircularProgressIndicator(
                strokeWidth: AppDimens.strokeAudioWidth(progressSize),
                backgroundColor: AppColors.dividerGrey,
                color: AppColors.black,
              )
            : CircularProgressIndicator(
                strokeWidth: AppDimens.strokeAudioWidth(progressSize),
                backgroundColor: AppColors.dividerGrey,
                color: AppColors.black,
                value: audioProgressType == AudioProgressType.current ? state.progress.clamp(0, 1) : progress,
              ),
      ),
    );
  }
}
