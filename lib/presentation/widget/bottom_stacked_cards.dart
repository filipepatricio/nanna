import 'dart:math';

import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:flutter/widgets.dart';

const _upperDiagonalCardHeight = 15.0;
const _upperDiagonalCardFillerHeight = 20.0;

class BottomStackedCards extends StatelessWidget {
  const BottomStackedCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: AppDimens.topicViewStackedCardsDividerHeight,
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            color: AppColors.lightGrey,
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowColor,
                offset: const Offset(10.0, 10.0),
                blurRadius: 10.0,
                spreadRadius: -2.0,
              ),
            ],
          ),
        ),
        Container(
          height: _upperDiagonalCardFillerHeight,
          color: AppColors.lightGrey,
          width: double.infinity,
        ),
        Positioned(
          child: Transform.rotate(
            angle: 3 * pi / 120,
            child: Container(
              height: _upperDiagonalCardHeight,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowColor,
                    offset: const Offset(0.0, 10.0),
                    blurRadius: 10.0,
                    spreadRadius: -2.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
