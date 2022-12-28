import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:flutter/material.dart';

class CardDivider extends StatelessWidget {
  const CardDivider.cover() : _height = AppDimens.s;

  const CardDivider.section() : _height = AppDimens.xl;

  final double _height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.of(context).shadowDividerColors,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}
