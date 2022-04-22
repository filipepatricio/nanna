import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:flutter/material.dart';

class InformedTooltip extends StatelessWidget {
  final String text;
  final String? actionButtonText;
  final VoidCallback? onActionButtonTap;
  final VoidCallback? onDismiss;
  final TextStyle style;

  const InformedTooltip({
    required this.text,
    this.actionButtonText,
    this.onActionButtonTap,
    this.onDismiss,
    this.style = AppTypography.b2Regular,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: const BoxDecoration(
            color: AppColors.pastelPurple,
            borderRadius: BorderRadius.all(
              Radius.circular(AppDimens.s),
            ),
          ),
          child: Stack(
            children: [
              if (onDismiss != null)
                Positioned(
                  top: AppDimens.s,
                  right: AppDimens.s,
                  child: IconButton(
                    icon: const Icon(Icons.close_rounded),
                    color: AppColors.textPrimary,
                    highlightColor: AppColors.transparent,
                    splashColor: AppColors.transparent,
                    alignment: Alignment.topRight,
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      onDismiss!();
                    },
                  ),
                ),
              Padding(
                padding:
                    const EdgeInsets.only(top: AppDimens.m, left: AppDimens.m, right: AppDimens.m, bottom: AppDimens.s),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppDimens.xs),
                      child: InformedMarkdownBody(
                        markdown: text,
                        baseTextStyle: style.copyWith(color: AppColors.textPrimary),
                      ),
                    ),
                    if (actionButtonText != null)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: onActionButtonTap,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: AppDimens.m),
                              child: Text(
                                actionButtonText!,
                                style: AppTypography.h5BoldSmall.copyWith(
                                  color: AppColors.textPrimary,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
