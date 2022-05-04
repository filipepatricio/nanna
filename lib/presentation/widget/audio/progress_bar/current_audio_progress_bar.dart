import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/audio/progress_bar/audio_progress_bar_cubit.dart';
import 'package:better_informed_mobile/presentation/widget/audio/progress_bar/audio_progress_bar_cubit_factory.di.dart';
import 'package:better_informed_mobile/presentation/widget/audio/progress_bar/audio_progress_bar_state.dt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CurrentAudioProgressBar extends HookWidget {
  const CurrentAudioProgressBar({Key? key}) : super(key: key);

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
      child: LinearProgressIndicator(
        value: state.progress,
        color: state.progressColor,
        backgroundColor: AppColors.transparent,
        minHeight: AppDimens.xs,
      ),
    );
  }
}

extension on AudioProgressBarState {
  double get progress {
    return map(
      inactive: (_) => 0.0,
      active: (state) => state.progress.inMilliseconds / state.totalDuration.inMilliseconds,
    );
  }

  Color get progressColor {
    return map(
      inactive: (_) => AppColors.textPrimary.withOpacity(0.7),
      active: (_) => AppColors.textPrimary,
    );
  }
}
