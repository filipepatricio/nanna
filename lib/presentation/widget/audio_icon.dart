import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

class AudioIcon extends HookWidget {
  const AudioIcon._({
    required this.color,
    this.height = AppDimens.ml,
    Key? key,
  }) : super(key: key);

  final Color color;
  final double? height;

  factory AudioIcon.dark({Color color = AppColors.textPrimary, double? height, Key? key}) => AudioIcon._(
        color: color,
        height: height,
        key: key,
      );

  factory AudioIcon.light({Color color = AppColors.white, double? height, Key? key}) => AudioIcon._(
        color: color,
        height: height,
        key: key,
      );

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      AppVectorGraphics.headphones,
      height: height,
      color: color,
    );
  }
}
