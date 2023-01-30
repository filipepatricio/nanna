import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/filled_button.dart';
import 'package:better_informed_mobile/presentation/widget/informed_svg.dart';
import 'package:flutter/material.dart';

class GeneralErrorView extends StatelessWidget {
  GeneralErrorView({
    required this.title,
    required this.content,
    this.svgPath,
    this.retryCallback,
    String? action,
    Key? key,
  })  : action = action ?? LocaleKeys.common_tryAgain.tr(),
        super(key: key);

  final String title;
  final String content;
  final String action;
  final String? svgPath;
  final VoidCallback? retryCallback;

  @override
  Widget build(BuildContext context) {
    final svg = svgPath;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (svg != null) ...[
          InformedSvg(svg),
          const SizedBox(height: AppDimens.l),
        ],
        Text.rich(
          textAlign: TextAlign.center,
          TextSpan(
            children: [
              TextSpan(
                text: '$title\n',
                style: AppTypography.h4Bold,
              ),
              TextSpan(
                text: content,
                style: AppTypography.h4Medium,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimens.l),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.c),
          child: retryCallback != null
              ? InformedFilledButton.primary(
                  context: context,
                  text: action,
                  onTap: retryCallback,
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
