import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/audio/progress_bar/audio_progress_bar_cubit.dart';
import 'package:better_informed_mobile/presentation/widget/audio/progress_bar/audio_progress_bar_cubit_factory.di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:percent_indicator/percent_indicator.dart';

class CurrentAudioFloatingProgress extends HookWidget {
  const CurrentAudioFloatingProgress(this.progressSize, {Key? key}) : super(key: key);

  final double progressSize;

  @override
  Widget build(BuildContext context) {
    final cubit = useCubitFactory<AudioProgressBarCubit, AudioProgressBarCubitFactory>(
      closeOnDispose: false,
    );
    final state = useCubitBuilder(cubit);

    useEffect(
      () {
        cubit.initialize();
      },
      [cubit],
    );

    return RepaintBoundary(
      child: CircularPercentIndicator(
        radius: progressSize * 0.5,
        backgroundColor: AppColors.dividerGrey,
        percent: state.progress > 1.0 ? 1 : state.progress,
        progressColor: state.progressColor,
        lineWidth: progressSize * 0.07,
        backgroundWidth: progressSize * 0.07,
        circularStrokeCap: CircularStrokeCap.round,
      ),
    );
  }
}
