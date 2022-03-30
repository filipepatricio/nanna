import 'package:better_informed_mobile/presentation/page/media/widgets/audio/rewind_button/audio_rewind_button_cubit.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/audio/rewind_button/audio_rewind_button_state.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AudioRewindButton extends HookWidget {
  const AudioRewindButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<AudioRewindButtonCubit>();
    final state = useCubitBuilder(cubit);

    useEffect(
      () {
        cubit.initialize();
      },
      [cubit],
    );

    return IconButton(
      onPressed: state.isEnabled ? cubit.rewind : null,
      padding: const EdgeInsets.only(right: AppDimens.s),
      icon: SvgPicture.asset(
        AppVectorGraphics.skip_back_10_seconds,
        color: state.imageColor,
      ),
    );
  }
}

extension on AudioRewindButtonState {
  bool get isEnabled {
    return map(
      disabled: (_) => false,
      enabled: (_) => true,
    );
  }

  Color get imageColor {
    return map(
      disabled: (_) => AppColors.textGrey,
      enabled: (_) => AppColors.textPrimary,
    );
  }
}
