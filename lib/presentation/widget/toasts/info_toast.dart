import 'dart:ui';

import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class InfoToast extends StatelessWidget {
  final String text;
  final VoidCallback? onDismiss;

  const InfoToast({
    required this.text,
    this.onDismiss,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQueryData.fromWindow(window).padding.top;
    final topPaddingFromSafeArea = MediaQuery.of(context).padding.top;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: -topPadding,
          left: 0,
          right: 0,
          child: Dismissible(
            key: const Key('tutorialSnackBar'),
            direction: DismissDirection.up,
            onDismissed: (direction) {
              onDismiss?.call();
            },
            child: Container(
              padding: EdgeInsets.only(
                left: AppDimens.l,
                right: AppDimens.l,
                top: AppDimens.l + topPaddingFromSafeArea,
                bottom: AppDimens.s,
              ),
              decoration: const BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowColor,
                    offset: Offset(0.0, 4.0),
                    blurRadius: 2.0,
                    spreadRadius: -1.0,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InformedMarkdownBody(
                    markdown: text,
                    baseTextStyle: AppTypography.b2Regular.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          dismissAllToast();
                          onDismiss?.call();
                        },
                        child: Text(
                          LocaleKeys.common_gotIt.tr(),
                          style: AppTypography.h4Bold.copyWith(
                            color: AppColors.textPrimary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
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
