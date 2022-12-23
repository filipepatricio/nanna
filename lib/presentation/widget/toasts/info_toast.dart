import 'dart:ui';

import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class InfoToast extends StatelessWidget {
  const InfoToast({
    required this.text,
    this.onDismiss,
    Key? key,
  }) : super(key: key);
  final String text;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQueryData.fromWindow(window).padding.top;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: -topPadding,
          left: AppDimens.l,
          right: AppDimens.l,
          child: Dismissible(
            key: const Key('tutorialSnackBar'),
            direction: DismissDirection.up,
            onDismissed: (direction) {
              onDismiss?.call();
            },
            child: Container(
              padding: const EdgeInsets.all(AppDimens.m),
              decoration: BoxDecoration(
                color: AppColors.of(context).blackWhiteSecondary,
                borderRadius: const BorderRadius.all(
                  Radius.circular(AppDimens.s),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.shadow20,
                    offset: Offset(0.0, 2.0),
                    blurRadius: 10.0,
                    spreadRadius: 0.0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  InformedMarkdownBody(
                    markdown: text,
                    baseTextStyle: AppTypography.b2Medium,
                  ),
                  const SizedBox(height: AppDimens.m),
                  TextButton(
                    onPressed: () {
                      dismissAllToast();
                      onDismiss?.call();
                    },
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      LocaleKeys.common_gotIt.tr(),
                      style: AppTypography.b2Regular,
                    ),
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
