import 'dart:math';

import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ReadingListStackedCards extends HookWidget {
  final Size coverSize;
  final Widget child;
  final bool center;

  const ReadingListStackedCards({
    required this.coverSize,
    required this.child,
    this.center = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bottomCardHeight = coverSize.height - coverSize.height / 24;
    final bottomCardWidth = coverSize.width - coverSize.width / 7;

    final topCardHeight = coverSize.height - coverSize.height / 12;
    final topCardWidth = coverSize.width - coverSize.width / 8;

    final middleCardTopMargin = (coverSize.height - topCardHeight) / 2 + AppDimens.l / 2;
    final middleCardHeight = topCardHeight - 10;
    final middleCardWidth = topCardWidth - topCardWidth / 12;

    return Stack(
      children: [
        Container(color: AppColors.background),
        Align(
          alignment: center ? Alignment.center : Alignment.centerLeft,
          child: Transform.rotate(
            angle: -3 * pi / 180,
            child: Container(
              height: bottomCardHeight,
              width: bottomCardWidth,
              decoration: BoxDecoration(
                color: AppColors.darkLinen,
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
          left: center ? -20 : 0,
          right: 0,
          top: middleCardTopMargin,
          child: Align(
            alignment: center ? Alignment.center : Alignment.centerLeft,
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
        ),
        Align(
          alignment: center ? Alignment.center : Alignment.centerLeft,
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
