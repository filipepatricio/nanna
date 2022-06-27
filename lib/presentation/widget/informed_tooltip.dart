import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:flutter/material.dart';

class InformedTooltip extends StatelessWidget {
  const InformedTooltip({
    required this.text,
    this.actionButtonText,
    this.onActionButtonTap,
    this.onDismiss,
    this.style = AppTypography.b2Regular,
    Key? key,
  }) : super(key: key);
  final String text;
  final String? actionButtonText;
  final VoidCallback? onActionButtonTap;
  final VoidCallback? onDismiss;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DecoratedBox(
          decoration: const BoxDecoration(
            color: AppColors.pastelPurple,
            borderRadius: BorderRadius.all(
              Radius.circular(AppDimens.s),
            ),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: AppDimens.m,
                  left: AppDimens.m,
                  right: AppDimens.m,
                  bottom: AppDimens.s,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppDimens.xs, right: AppDimens.ml),
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
              if (onDismiss != null)
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    icon: const Icon(Icons.close_rounded),
                    color: AppColors.textPrimary,
                    highlightColor: AppColors.transparent,
                    splashColor: AppColors.transparent,
                    padding: const EdgeInsets.all(AppDimens.sl),
                    onPressed: () {
                      onDismiss!();
                    },
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
