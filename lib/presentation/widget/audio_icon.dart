import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

class AudioIcon extends HookWidget {
  const AudioIcon._({
    required this.color,
    Key? key,
  }) : super(key: key);

  final Color color;

  factory AudioIcon.dark({Color color = AppColors.textPrimary, Key? key}) => AudioIcon._(
        color: color,
        key: key,
      );

  factory AudioIcon.light({Color color = AppColors.white, Key? key}) => AudioIcon._(
        color: color,
        key: key,
      );

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      AppVectorGraphics.headphones,
      height: AppDimens.ml,
      color: color,
    );
  }
}
