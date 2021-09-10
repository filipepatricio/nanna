import 'dart:math';

import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ReadingListStackedCards extends HookWidget {
  final Size coverSize;
  final Widget child;

  const ReadingListStackedCards({
    required this.coverSize,
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bottomCardHeight = coverSize.height - AppDimens.l;
    final bottomCardWidth = coverSize.width - coverSize.width / 7;

    final topCardHeight = coverSize.height - AppDimens.l - 40;
    final topCardWidth = coverSize.width - coverSize.width / 8;

    final middleCardTopMargin = (coverSize.height - topCardHeight) / 2 + AppDimens.l / 2;
    final middleCardHeight = topCardHeight - 10;
    final middleCardWidth = topCardWidth - 40;

    return Stack(
      children: [
        Container(color: AppColors.background),
        Align(
          alignment: Alignment.centerLeft,
          child: Transform.rotate(
            angle: -3 * pi / 180,
            child: Container(
              height: bottomCardHeight,
              width: bottomCardWidth,
              decoration: BoxDecoration(
                color: const Color(0xffF4F1EE),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowColor,
                    offset: const Offset(0.0, 4.0),
                    blurRadius: 2.0,
                    spreadRadius: -1.0,
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          top: middleCardTopMargin,
          child: Transform.rotate(
            angle: -5 * pi / 180,
            child: Container(
              height: middleCardHeight,
              width: middleCardWidth,
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowColor,
                    offset: const Offset(0.0, 4.0),
                    blurRadius: 1,
                    spreadRadius: -1,
                  ),
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            height: topCardHeight,
            width: topCardWidth,
            decoration: BoxDecoration(
              color: AppColors.background,
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowColor,
                  offset: const Offset(0.0, 4.0),
                  blurRadius: 2.0,
                  spreadRadius: -1.0,
                ),
              ],
            ),
            child: child,
          ),
        ),
      ],
    );
  }
}
