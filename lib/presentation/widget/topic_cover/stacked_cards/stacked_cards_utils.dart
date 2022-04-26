import 'dart:math';

import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:flutter/material.dart';

double calculateCornersHeightDifference({
  required Offset leftCorner,
  required Offset rightCorner,
  required Offset origin,
  required double angle,
}) {
  const angleInRadians = -5 * pi * 180;

  final rotatedLeftTopY = origin.dy + (leftCorner.dx * sin(angleInRadians) - leftCorner.dy * cos(angleInRadians));
  final rotatedRightTopY = origin.dy + (rightCorner.dx * sin(angleInRadians) - rightCorner.dy * cos(angleInRadians));

  return (rotatedLeftTopY - rotatedRightTopY).abs();
}

const cardHeightScale = 388 / 400;
const cardWidthScale = 274 / 327;

const stackedCardsShadow = [
  BoxShadow(
    color: AppColors.shadowColor,
    offset: Offset(0.0, 3.0),
    blurRadius: 4.0,
    spreadRadius: 1,
  ),
];

const stackedCardsBorder = BorderRadius.all(
  Radius.circular(AppDimens.m),
);
