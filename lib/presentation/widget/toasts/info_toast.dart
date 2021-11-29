import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import '../informed_markdown_body.dart';

class InfoToast extends StatelessWidget {
  final String text;
  final VoidCallback? onDismiss;

  const InfoToast({required this.text, this.onDismiss, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: const Key('tutorialSnackBar'),
        direction: DismissDirection.up,
        onDismissed: (direction) {
          if (onDismiss != null) {
            onDismiss!();
          }
        },
        child: Container(
            padding:
                const EdgeInsets.only(left: AppDimens.l, right: AppDimens.l, top: AppDimens.xxxl, bottom: AppDimens.s),
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
                InformedMarkdownBody(
                  markdown: text,
                  baseTextStyle: AppTypography.h4Normal.copyWith(color: AppColors.textPrimary),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          dismissAllToast();
                          if (onDismiss != null) {
                            onDismiss!();
                          }
                        },
                        child: Text(
                          LocaleKeys.common_gotIt.tr(),
                          style: AppTypography.h4Bold
                              .copyWith(color: AppColors.textPrimary, decoration: TextDecoration.underline),
                        ))
                  ],
                ),
              ],
            )));
  }
}
