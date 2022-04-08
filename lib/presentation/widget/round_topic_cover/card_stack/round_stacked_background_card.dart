import 'dart:math';

import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/widget/round_topic_cover/card_stack/round_stacked_card_style.dart';
import 'package:flutter/material.dart';

class RoundStackedBackgroundCard extends StatelessWidget {
  const RoundStackedBackgroundCard({
    required this.width,
    required this.height,
    required this.rotation,
    required this.topMargin,
    Key? key,
  }) : super(key: key);

  final double width;
  final double height;
  final double rotation;
  final double topMargin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topMargin),
      child: Container(
        transformAlignment: Alignment.center,
        transform: Matrix4.identity()..rotateZ(rotation * pi / 180),
        width: width,
        height: height,
        decoration: const BoxDecoration(
          borderRadius: roundedStackedCardsBorder,
          color: AppColors.darkLinen,
          boxShadow: roundedStackedCardsShadow,
        ),
      ),
    );
  }
}