import 'dart:math';

import 'package:better_informed_mobile/presentation/widget/stacked_cards/stacked_card_shadow.dart';
import 'package:flutter/material.dart';

class StackedCardItem extends StatelessWidget {
  final double height;
  final double width;
  final bool centered;
  final Color color;
  final double rotation;

  const StackedCardItem({
    required this.height,
    required this.width,
    required this.centered,
    required this.color,
    this.rotation = 0.0,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: centered ? Alignment.center : Alignment.centerLeft,
      child: Transform.rotate(
        angle: rotation * pi / 180,
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: color,
            boxShadow: getStackedCardShadow(),
          ),
        ),
      ),
    );
  }
}
