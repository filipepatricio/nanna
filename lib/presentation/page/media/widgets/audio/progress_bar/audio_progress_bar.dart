import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/audio/progress_bar/audio_progress_bar_cubit.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const _barHeight = 3.0;
const _thumbRadius = 6.0;
const _thumbGlowRadius = 15.0;

class AudioProgressProgressBar extends HookWidget {
  const AudioProgressProgressBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<AudioProgressBarCubit>();
    final state = useCubitBuilder(cubit);

    useEffect(
      () {
        cubit.initialize();
      },
      [cubit],
    );

    return state.map(
      inactive: (_) => const _InactiveProgressbar(),
      active: (state) => _ActiveProgressBar(
        cubit: cubit,
        position: state.progress,
        totalDuration: state.totalDuration,
      ),
    );
  }
}

class _ActiveProgressBar extends StatelessWidget {
  const _ActiveProgressBar({
    required this.cubit,
    required this.position,
    required this.totalDuration,
    Key? key,
  }) : super(key: key);

  final AudioProgressBarCubit cubit;
  final Duration position;
  final Duration totalDuration;

  @override
  Widget build(BuildContext context) {
    return ProgressBar(
      progress: position,
      total: totalDuration,
      progressBarColor: AppColors.textPrimary,
      baseBarColor: AppColors.grey,
      bufferedBarColor: AppColors.transparent,
      thumbColor: AppColors.textPrimary,
      barHeight: _barHeight,
      thumbRadius: _thumbRadius,
      thumbGlowRadius: _thumbGlowRadius,
      timeLabelLocation: TimeLabelLocation.sides,
      timeLabelTextStyle: AppTypography.timeLabelText,
      onSeek: cubit.seek,
    );
  }
}

class _InactiveProgressbar extends StatelessWidget {
  const _InactiveProgressbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProgressBar(
      progress: Duration.zero,
      total: Duration.zero,
      progressBarColor: AppColors.textPrimary.withOpacity(0.7),
      baseBarColor: AppColors.grey.withOpacity(0.7),
      bufferedBarColor: AppColors.transparent,
      thumbColor: AppColors.textPrimary.withOpacity(0.7),
      barHeight: _barHeight,
      thumbRadius: _thumbRadius,
      thumbGlowRadius: _thumbGlowRadius,
      timeLabelLocation: TimeLabelLocation.sides,
      timeLabelTextStyle: AppTypography.timeLabelText.copyWith(
        color: AppColors.textPrimary.withOpacity(0.7),
      ),
    );
  }
}
