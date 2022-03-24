import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:flutter/material.dart';

const roundCardHeightScale = 388 / 400;
const roundCardWidthScale = 274 / 327;

const roundedStackedCardsShadow = [
  BoxShadow(
    color: AppColors.shadowColor,
    offset: Offset(0.0, 3.0),
    blurRadius: 4.0,
    spreadRadius: 1,
  ),
];

const roundedStackedCardsBorder = BorderRadius.all(
  Radius.circular(AppDimens.m),
);
