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
      height: AppDimens.xl,
      width: AppDimens.xl,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.white, width: 1),
        color: AppColors.black,
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Icon(
          Icons.check,
          color: AppColors.white,
          size: AppDimens.ml,
        ),
      ),
    );
  }
}
