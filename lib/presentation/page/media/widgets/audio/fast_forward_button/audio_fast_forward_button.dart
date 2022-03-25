import 'package:better_informed_mobile/presentation/page/media/widgets/audio/fast_forward_button/audio_fast_forward_button_cubit.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AudioFastForwardButton extends HookWidget {
  const AudioFastForwardButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<AufioFastForwardButtonCubit>();

    return IconButton(
      onPressed: cubit.fastForward,
      padding: const EdgeInsets.only(right: AppDimens.s),
      icon: SvgPicture.asset(
        AppVectorGraphics.skip_forward_10_seconds,
        color: AppColors.textPrimary,
      ),
    );
  }
}
