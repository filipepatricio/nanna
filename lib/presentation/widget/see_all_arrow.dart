import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SeeAllArrow extends StatelessWidget {
  const SeeAllArrow({
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.all(0),
      onPressed: onTap,
      icon: SvgPicture.asset(
        AppVectorGraphics.fullArrowRight,
        fit: BoxFit.contain,
      ),
      alignment: Alignment.centerRight,
    );
  }
}
