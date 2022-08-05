import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:flutter/material.dart';

class InformedDivider extends StatelessWidget {
  const InformedDivider({
    this.padding = EdgeInsets.zero,
    Key? key,
  }) : super(key: key);

  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Container(
        height: 1.0,
        color: AppColors.dividerGreyLight,
      ),
    );
  }
}
