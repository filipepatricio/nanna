import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/informed_svg.dart';
import 'package:flutter/material.dart';

class VisitedCheck extends StatelessWidget {
  const VisitedCheck({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const InformedSvg(
      AppVectorGraphics.visitedCheckmark,
      colored: false,
    );
  }
}
