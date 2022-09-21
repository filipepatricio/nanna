import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

enum LockerMode { image, color }

const _asset = AppVectorGraphics.locker;

class Locker extends StatelessWidget {
  const Locker({
    required this.mode,
    Key? key,
  }) : super(key: key);

  const Locker.color() : this(mode: LockerMode.color);

  const Locker.image() : this(mode: LockerMode.image);

  final LockerMode mode;

  @override
  Widget build(BuildContext context) {
    switch (mode) {
      case LockerMode.color:
        return SvgPicture.asset(_asset);
      case LockerMode.image:
        return SvgPicture.asset(
          _asset,
          color: AppColors.white,
        );
    }
  }
}
