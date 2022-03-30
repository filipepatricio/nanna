import 'package:better_informed_mobile/presentation/page/media/widgets/audio/speed_button/audio_speed_button_cubit.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/bordered_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AudioSpeedButton extends HookWidget {
  const AudioSpeedButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<AudioSpeedButtonCubit>();
    final state = useCubitBuilder(cubit);

    useEffect(
      () {
        cubit.initialize();
      },
      [cubit],
    );

    return BorderedButton(
      text: Text(
        'Speed 1.0x',
        style: AppTypography.h5BoldSmall.copyWith(height: 1.2),
      ),
      onTap: cubit.switchSpeed,
    );
  }
}
