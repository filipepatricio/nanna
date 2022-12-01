import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class VisitedCheck extends StatelessWidget {
  const VisitedCheck({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      AppVectorGraphics.visitedCheckmark,
    );
  }
}
