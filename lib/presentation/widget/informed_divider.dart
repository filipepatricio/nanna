import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:flutter/material.dart';

class InformedDivider extends StatelessWidget {
  const InformedDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1.0,
      color: AppColors.greyDividerColor,
    );
  }
}
