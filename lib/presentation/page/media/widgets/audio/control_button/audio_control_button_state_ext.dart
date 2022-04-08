import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/audio/control_button/audio_control_button_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/audio/control_button/audio_control_button_state.dt.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:flutter/widgets.dart';

extension AudioControlButtonStateViewExtension on AudioControlButtonState {
  Function()? getAction(
    AudioControlButtonCubit cubit,
    MediaItemArticle article,
    String? imageUrl,
  ) {
    return map(
      notInitilized: (_) => () => cubit.play(article, imageUrl),
      loading: (_) => null,
      playing: (_) => () => cubit.pause(),
      paused: (_) => () => cubit.play(article, imageUrl),
    );
  }

  String get imagePath {
    return map(
      notInitilized: (_) => AppVectorGraphics.play_arrow,
      loading: (_) => AppVectorGraphics.play_arrow,
      playing: (_) => AppVectorGraphics.pause,
      paused: (_) => AppVectorGraphics.play_arrow,
    );
  }

  Color get imageColor {
    return map(
      notInitilized: (_) => AppColors.textPrimary,
      loading: (_) => AppColors.textGrey,
      playing: (_) => AppColors.textPrimary,
      paused: (_) => AppColors.textPrimary,
    );
  }
}
