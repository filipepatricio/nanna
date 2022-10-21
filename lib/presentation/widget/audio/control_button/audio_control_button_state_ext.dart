import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/audio/control_button/audio_control_button_cubit.di.dart';
import 'package:better_informed_mobile/presentation/widget/audio/control_button/audio_control_button_state.dt.dart';

enum AudioProgressType { current, other, loading }

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

  double get progress {
    return maybeMap(
      notInitilized: (e) => e.progress,
      inDifferentAudio: (e) => e.progress,
      loading: (_) => 0.0,
      playing: (_) => 0.0,
      paused: (_) => 0.0,
      orElse: () => throw Exception('Unhandled type'),
    );
  }

  AudioProgressType get audioType {
    return maybeMap(
      notInitilized: (_) => AudioProgressType.other,
      inDifferentAudio: (_) => AudioProgressType.other,
      loading: (_) => AudioProgressType.loading,
      playing: (_) => AudioProgressType.current,
      paused: (_) => AudioProgressType.current,
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

  int get imageAlpha {
    return maybeMap(
      notInitilized: (_) => 255,
      inDifferentAudio: (_) => 255,
      loading: (_) => 150,
      playing: (_) => 255,
      paused: (_) => 255,
      orElse: () => throw Exception('Unhandled type'),
    );
  }
}
