import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/widget/audio/control_button/audio_floating_control_button.dart';
import 'package:flutter/material.dart';

class ArticleCoverAudioButton extends StatelessWidget {
  const ArticleCoverAudioButton({
    required this.article,
    required this.audioFloatingControlButtonMode,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;
  final AudioFloatingControlButtonMode audioFloatingControlButtonMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppDimens.audioControlButtonSize,
      height: AppDimens.audioControlButtonSize,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: AppColors.black05, blurRadius: 5.0),
        ],
      ),
      child: AudioFloatingControlButton(
        article: article,
        elevation: 0,
        color: audioFloatingControlButtonMode == AudioFloatingControlButtonMode.white
            ? AppColors.transparent
            : AppColors.white,
        progressSize: AppDimens.audioControlButtonSize,
        mode: audioFloatingControlButtonMode,
      ),
    );
  }
}
