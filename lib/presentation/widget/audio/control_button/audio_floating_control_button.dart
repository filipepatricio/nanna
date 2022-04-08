import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/audio/control_button/audio_control_button_cubit.di.dart';
import 'package:better_informed_mobile/presentation/widget/audio/control_button/audio_control_button_state_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AudioFloatingControlButton extends HookWidget {
  const AudioFloatingControlButton({
    required this.article,
    this.elevation,
    Key? key,
  }) : super(key: key);

  const AudioFloatingControlButton.forCurrentAudio({
    this.elevation,
    Key? key,
  })  : article = null,
        super(key: key);

  final MediaItemArticle? article;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    final imageUrl = useCloudinaryImageUrl(
      article?.image?.publicId,
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

    useEffect(
      () {
        cubit.initialize();
      },
      [cubit, article],
    );

    return FloatingActionButton(
      elevation: elevation,
      highlightElevation: elevation,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: elevation != null ? AppColors.grey : AppColors.transparent),
        borderRadius: BorderRadius.circular(AppDimens.xl),
      ),
      onPressed: state.getAction(cubit),
      backgroundColor: AppColors.white,
      child: Center(
        child: SvgPicture.asset(
          state.imagePath,
          height: AppDimens.sl + AppDimens.xxs,
          color: state.imageColor,
        ),
      ),
    );
  }
}
