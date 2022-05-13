import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

enum TutorialTooltipPosition { top, bottom }

class TutorialTooltip extends StatelessWidget {
  final String text;
  final int tutorialIndex;
  final int tutorialLength;
  final String dismissButtonText;
  final TutorialTooltipPosition tutorialTooltipPosition;
  final VoidCallback? onDismiss;

  const TutorialTooltip({
    required this.text,
    required this.tutorialIndex,
    required this.tutorialLength,
    required this.dismissButtonText,
    required this.tutorialTooltipPosition,
    this.onDismiss,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (tutorialTooltipPosition == TutorialTooltipPosition.bottom) ...[
          Padding(
            padding: const EdgeInsets.only(left: 250, bottom: AppDimens.s),
            child: SvgPicture.asset(AppVectorGraphics.tutorialArrowUp),
          )
        ],
        DecoratedBox(
          decoration: tutorialTooltipPosition == TutorialTooltipPosition.top
              ? const BoxDecoration(
                  color: AppColors.pastelPurple,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppDimens.m),
                    topRight: Radius.circular(AppDimens.m),
                    bottomRight: Radius.circular(AppDimens.m),
                  ),
                )
              : const BoxDecoration(
                  color: AppColors.pastelPurple,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(AppDimens.m),
                    topRight: Radius.circular(AppDimens.m),
                    bottomRight: Radius.circular(AppDimens.m),
                  ),
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
                    Expanded(
                      child: InformedMarkdownBody(
                        markdown: '**${tutorialIndex + 1}**/$tutorialLength',
                        baseTextStyle: AppTypography.b2Regular
                            .copyWith(color: AppColors.textPrimary, decoration: TextDecoration.underline),
                      ),
                    ),
                    TextButton(
                      onPressed: onDismiss,
                      child: Text(
                        dismissButtonText,
                        style: AppTypography.h4Bold
                            .copyWith(color: AppColors.textPrimary, decoration: TextDecoration.underline),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        if (tutorialTooltipPosition == TutorialTooltipPosition.top) ...[
          Padding(
            padding: const EdgeInsets.only(left: AppDimens.m, top: AppDimens.s),
            child: SvgPicture.asset(AppVectorGraphics.tutorialArrowDown),
          )
        ]
      ],
    );
  }
}
