import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:flutter/material.dart';

List<BoxShadow> getStackedCardShadow() => [
      BoxShadow(
        color: AppColors.shadowColor,
        offset: const Offset(0.0, 4.0),
        blurRadius: 2.0,
        spreadRadius: -1.0,
      ),
    ];
