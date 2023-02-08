import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/filled_button.dart';
import 'package:better_informed_mobile/presentation/widget/informed_svg.dart';
import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  ErrorView({
    required this.title,
    required this.content,
    this.svgPath,
    this.retryCallback,
    String? action,
    super.key,
  }) : action = action ?? LocaleKeys.common_tryAgain.tr();

  factory ErrorView.general({VoidCallback? retryCallback}) => ErrorView(
        title: LocaleKeys.common_error_title.tr(),
        content: LocaleKeys.common_error_body.tr(),
        action: LocaleKeys.common_tryAgain.tr(),
        retryCallback: retryCallback,
      );

  factory ErrorView.offline({
    required VoidCallback retryCallback,
  }) =>
      ErrorView(
        title: LocaleKeys.noConnection_errorView_title.tr(),
        content: LocaleKeys.noConnection_errorView_body.tr(),
        retryCallback: retryCallback,
        svgPath: AppVectorGraphics.error,
      );

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
          const SizedBox(height: AppDimens.s),
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
        if (retryCallback != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.c),
            child: InformedFilledButton.primary(
              context: context,
              text: action,
              onTap: retryCallback,
            ),
          ),
      ],
    );
  }
}
