import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/audio/seek_button/audio_seek_button_cubit.di.dart';
import 'package:better_informed_mobile/presentation/widget/audio/seek_button/audio_seek_button_state.dt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum AudioSeekButtonType { rewind, fastForward }

class AudioSeekButton extends HookWidget {
  const AudioSeekButton._({
    required this.type,
    Key? key,
  }) : super(key: key);

  const AudioSeekButton.rewind() : this._(type: AudioSeekButtonType.rewind);

  const AudioSeekButton.fastForward() : this._(type: AudioSeekButtonType.fastForward);

  final AudioSeekButtonType type;

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<AudioSeekButtonCubit>();
    final state = useCubitBuilder(cubit);

    useEffect(
      () {
        cubit.initialize();
      },
      [cubit],
    );

    switch (type) {
      case AudioSeekButtonType.rewind:
        return _RewindButton(
          cubit: cubit,
          state: state,
        );
      case AudioSeekButtonType.fastForward:
        return _FastForwardButton(
          cubit: cubit,
          state: state,
        );
    }
  }
}

class _RewindButton extends StatelessWidget {
  const _RewindButton({
    required this.cubit,
    required this.state,
    Key? key,
  }) : super(key: key);

  final AudioSeekButtonCubit cubit;
  final AudioSeekButtonState state;

  @override
  Widget build(BuildContext context) {
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

class _FastForwardButton extends StatelessWidget {
  const _FastForwardButton({
    required this.cubit,
    required this.state,
    Key? key,
  }) : super(key: key);

  final AudioSeekButtonCubit cubit;
  final AudioSeekButtonState state;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: state.isEnabled ? cubit.fastForward : null,
      padding: const EdgeInsets.only(right: AppDimens.s),
      icon: SvgPicture.asset(
        AppVectorGraphics.skip_forward_10_seconds,
        color: state.imageColor,
      ),
    );
  }
}

extension on AudioSeekButtonState {
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
