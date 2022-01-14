import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/widget/stacked_cards/stacked_card_shadow.dart';
import 'package:flutter/material.dart';

class StackedCardContent extends StatelessWidget {
  final bool centered;
  final double width;
  final double height;
  final Widget child;

  const StackedCardContent({
    required this.centered,
    required this.width,
    required this.height,
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: centered ? Alignment.center : Alignment.centerLeft,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: AppColors.background,
          boxShadow: getStackedCardShadow(),
        ),
        child: child,
      ),
    );
  }
}
