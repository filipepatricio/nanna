import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/audio/control_button/audio_control_button_cubit.di.dart';
import 'package:better_informed_mobile/presentation/widget/audio/control_button/audio_control_button_state.dt.dart';
import 'package:flutter/widgets.dart';

extension AudioControlButtonStateViewExtension on AudioControlButtonState {
  Function()? getAction(
    AudioControlButtonCubit cubit,
  ) {
    return maybeMap(
      notInitilized: (_) => () => cubit.play(),
      inDifferentAudio: (_) => () => cubit.play(),
      loading: (_) => null,
      playing: (_) => () => cubit.pause(),
      paused: (_) => () => cubit.play(),
      orElse: () => throw Exception('Unhandled type'),
    );
  }

  bool showProgress(MediaItemArticle? article) {
    return maybeMap(
      notInitilized: (_) => false,
      inDifferentAudio: (_) => false,
      loading: (_) => article != null,
      playing: (_) => article != null,
      paused: (_) => article != null,
      orElse: () => throw Exception('Unhandled type'),
    );
  }

  String get imagePath {
    return maybeMap(
      notInitilized: (_) => AppVectorGraphics.playArrow,
      inDifferentAudio: (_) => AppVectorGraphics.playArrow,
      loading: (_) => AppVectorGraphics.playArrow,
      playing: (_) => AppVectorGraphics.pause,
      paused: (_) => AppVectorGraphics.playArrow,
      orElse: () => throw Exception('Unhandled type'),
    );
  }

  Color get imageColor {
    return maybeMap(
      notInitilized: (_) => AppColors.textPrimary,
      inDifferentAudio: (_) => AppColors.textPrimary,
      loading: (_) => AppColors.textGrey,
      playing: (_) => AppColors.textPrimary,
      paused: (_) => AppColors.textPrimary,
      orElse: () => throw Exception('Unhandled type'),
    );
  }
}
