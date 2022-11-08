import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/shadows.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:flutter/material.dart';

class TutorialTooltip extends StatelessWidget {
  const TutorialTooltip({
    required this.text,
    required this.dismissButtonText,
    this.onDismiss,
    this.tutorialIndex,
    this.tutorialLength,
    Key? key,
  }) : super(key: key);

  final String text;
  final int? tutorialIndex;
  final int? tutorialLength;
  final String dismissButtonText;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DecoratedBox(
          decoration: const BoxDecoration(
            color: AppColors.snackBarInformative,
            borderRadius: BorderRadius.all(
              Radius.circular(AppDimens.m),
            ),
            boxShadow: cardShadows,
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(top: AppDimens.m, left: AppDimens.m, right: AppDimens.m, bottom: AppDimens.s),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: AppDimens.s),
                  child: InformedMarkdownBody(
                    markdown: text,
                    baseTextStyle: AppTypography.b2Regular.copyWith(color: AppColors.textPrimary),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (tutorialIndex != null && tutorialLength != null)
                      Expanded(
                        child: InformedMarkdownBody(
                          markdown: '**${tutorialIndex! + 1}**/$tutorialLength',
                          baseTextStyle: AppTypography.b2Regular.copyWith(color: AppColors.textPrimary),
                        ),
                      )
                    else
                      const Spacer(),
                    TextButton(
                      onPressed: onDismiss,
                      child: Text(
                        dismissButtonText,
                        style: AppTypography.h4Bold.copyWith(color: AppColors.textPrimary),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
