import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class TutorialSnackBar extends StatelessWidget {
  final String title;
  final String message;

  const TutorialSnackBar({required this.title, required this.message, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 40, bottom: 6),
      decoration: BoxDecoration(color: AppColors.white, boxShadow: [
        BoxShadow(
          color: AppColors.shadowColor,
          offset: const Offset(0.0, 4.0),
          blurRadius: 2.0,
          spreadRadius: -1.0,
        ),
      ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RichText(
            textAlign: TextAlign.left,
            text: TextSpan(children: <TextSpan>[
              TextSpan(text: title, style: AppTypography.h4Bold.copyWith(color: AppColors.textPrimary)),
              TextSpan(text: message, style: AppTypography.h4Normal.copyWith(color: AppColors.textPrimary)),
            ]),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: dismissAllToast,
                  child: Text(
                    LocaleKeys.tutorial_gotIt.tr(),
                    style: AppTypography.h4Bold
                        .copyWith(color: AppColors.textPrimary, decoration: TextDecoration.underline),
                  ))
            ],
          ),
        ],
      ),
    );
  }
}
