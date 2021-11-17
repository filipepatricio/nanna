import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TutorialTooltip extends StatelessWidget {
  final String text;
  final String dismissButtonText;
  final VoidCallback? onDismiss;

  const TutorialTooltip({required this.text, required this.dismissButtonText, this.onDismiss, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.pastelPurple,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppDimens.m),
            topRight: Radius.circular(AppDimens.m),
            bottomRight: Radius.circular(AppDimens.m)),
      ),
      child: Padding(
          padding: const EdgeInsets.only(top: AppDimens.m, left: AppDimens.m, right: AppDimens.m, bottom: AppDimens.s),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: AppDimens.s),
                child: Text(
                  text,
                  style: AppTypography.h4Normal.copyWith(color: AppColors.textPrimary),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: onDismiss,
                      child: Text(
                        dismissButtonText,
                        style: AppTypography.h4Bold
                            .copyWith(color: AppColors.textPrimary, decoration: TextDecoration.underline),
                      ))
                ],
              ),
            ],
          )),
    );
  }
}
