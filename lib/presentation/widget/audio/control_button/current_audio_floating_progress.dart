import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/audio/control_button/audio_control_button_state_ext.dart';
import 'package:better_informed_mobile/presentation/widget/audio/progress_bar/audio_progress_bar_cubit.dart';
import 'package:better_informed_mobile/presentation/widget/audio/progress_bar/audio_progress_bar_cubit_factory.di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CurrentAudioFloatingProgress extends HookWidget {
  const CurrentAudioFloatingProgress({
    required this.progressSize,
    required this.progress,
    required this.audioProgressType,
    required this.progressBarColor,
    required this.showProgress,
    Key? key,
  }) : super(key: key);

  final double progressSize;
  final double progress;
  final AudioProgressType audioProgressType;
  final Color progressBarColor;
  final bool showProgress;

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
                color: progressBarColor,
              )
            : showProgress
                ? CircularProgressIndicator(
                    strokeWidth: AppDimens.strokeAudioWidth(progressSize),
                    color: progressBarColor,
                    value: audioProgressType == AudioProgressType.current ? state.progress.clamp(0, 1) : progress,
                  )
                : const SizedBox(),
      ),
    );
  }
}
