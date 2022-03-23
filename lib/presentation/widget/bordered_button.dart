import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:flutter/material.dart';

class BorderedButton extends StatelessWidget {
  const BorderedButton({
    required this.text,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final Text text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.textPrimary,
            width: 1.0,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(
              AppDimens.s,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.m,
          vertical: AppDimens.sl,
        ),
        child: Center(
          child: text,
        ),
      ),
    );
  }
}
