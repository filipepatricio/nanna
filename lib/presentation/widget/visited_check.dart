import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:flutter/material.dart';

class VisitedCheck extends StatelessWidget {
  const VisitedCheck({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimens.l,
      width: AppDimens.l,
      decoration: const BoxDecoration(
        color: AppColors.limeGreen,
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Icon(
          Icons.check,
          color: AppColors.black,
          size: AppDimens.ml,
        ),
      ),
    );
  }
}
