import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/audio/control_button/audio_control_button_cubit.di.dart';
import 'package:better_informed_mobile/presentation/widget/audio/control_button/audio_control_button_state.dt.dart';
import 'package:better_informed_mobile/presentation/widget/audio/control_button/audio_control_button_state_ext.dart';
import 'package:better_informed_mobile/presentation/widget/audio/switch_audio/switch_audio_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AudioControlButton extends HookWidget {
  const AudioControlButton({
    required this.article,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;

  @override
  Widget build(BuildContext context) {
    final imageUrl = useCloudinaryImageUrl(
      article,
      AppDimens.articleAudioCoverSize,
      AppDimens.articleAudioCoverSize,
    );
    final cubit = useCubitFactory<AudioControlButtonCubit, AudioControlButtonCubitFactory>(
      onCubitCreate: (factory) {
        factory.configure(article: article, imageUrl: imageUrl);
      },
      keys: [article],
    );
    final state = useCubitBuilder(cubit);

    useCubitListener<AudioControlButtonCubit, AudioControlButtonState>(
      cubit,
      (cubit, state, context) {
        state.mapOrNull(
          showSwitchAudioPopup: (_) async {
            final shouldSwitch = await showSwitchAudioPopup(context);
            if (shouldSwitch) {
              await cubit.play(true);
            }
          },
        );
      },
    );

    useEffect(
      () {
        cubit.initialize();
      },
      [cubit],
    );

    return IconButton(
      onPressed: state.getAction(cubit),
      padding: const EdgeInsets.only(right: AppDimens.s),
      icon: SvgPicture.asset(
        state.imagePath,
        color: state.imageColor,
      ),
    );
  }
}
