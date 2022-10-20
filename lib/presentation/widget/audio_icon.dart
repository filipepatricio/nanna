import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/widget/audio/control_button/audio_floating_control_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const _iconHeightImagePercentage = 0.8;

class AudioIconButton extends HookWidget {
  const AudioIconButton({
    required this.article,
    this.height = AppDimens.xl,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: height,
      child: AudioFloatingControlButton(
        article: article,
        elevation: 0,
        color: AppColors.lightGrey,
        imageHeight: height * _iconHeightImagePercentage,
        progressSize: height,
      ),
    );
  }
}
