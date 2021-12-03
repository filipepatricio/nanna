import 'dart:math';

import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:flutter/widgets.dart';

const bottomSquareCardHeight = 40.0;
const upperDiagonalCardHeight = 20.0;
const upperDiagonalCardFillerHeight = 20.0;

class BottomStackedCards extends StatelessWidget {
  const BottomStackedCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: bottomSquareCardHeight,
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            color: AppColors.lightGrey,
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
        Container(
          height: upperDiagonalCardFillerHeight,
          color: AppColors.lightGrey,
          width: double.infinity,
        ),
        Positioned(
          child: Transform.rotate(
            angle: 3 * pi / 120,
            child: Container(
              height: upperDiagonalCardHeight,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
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
      ],
    );
  }
}
