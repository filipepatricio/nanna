import 'package:better_informed_mobile/presentation/page/media/widgets/audio/control_button/audio_control_button_cubit.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/audio/control_button/audio_control_button_state.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AudioFloatingControlButton extends HookWidget {
  const AudioFloatingControlButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<AudioControlButtonCubit>();
    final state = useCubitBuilder(cubit);

    useEffect(
      () {
        cubit.initialize();
      },
      [cubit],
    );

    return FloatingActionButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.xl)),
      onPressed: state.getAction(cubit),
      backgroundColor: AppColors.white,
      child: Center(
        child: SvgPicture.asset(
          state.imagePath,
          height: AppDimens.sl + AppDimens.xs,
          color: state.imageColor,
        ),
      ),
    );
  }
}

extension on AudioControlButtonState {
  Function()? getAction(AudioControlButtonCubit cubit) {
    return map(
      initializing: (_) => null,
      playing: (_) => () => cubit.pause(),
      paused: (_) => () => cubit.play(),
    );
  }

  String get imagePath {
    return map(
      initializing: (_) => AppVectorGraphics.play_arrow,
      playing: (_) => AppVectorGraphics.pause,
      paused: (_) => AppVectorGraphics.play_arrow,
    );
  }

  Color get imageColor {
    return map(
      initializing: (_) => AppColors.textGrey,
      playing: (_) => AppColors.textPrimary,
      paused: (_) => AppColors.textPrimary,
    );
  }
}
