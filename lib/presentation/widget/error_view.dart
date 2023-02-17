import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/filled_button.dart';
import 'package:better_informed_mobile/presentation/widget/informed_svg.dart';
import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({
    this.type = ErrorViewType.general,
    this.title,
    this.content,
    this.svgPath,
    this.retryCallback,
    this.action,
    super.key,
  });

  factory ErrorView.offline({required VoidCallback retryCallback}) => ErrorView(
        type: ErrorViewType.offline,
        retryCallback: retryCallback,
        svgPath: AppVectorGraphics.error,
      );

  final ErrorViewType type;
  final String? title;
  final String? content;
  final String? action;
  final String? svgPath;
  final VoidCallback? retryCallback;

  @override
  Widget build(BuildContext context) {
    final title = this.title ?? type.title(context);
    final content = this.content ?? type.content(context);
    final action = this.action ?? type.action(context);

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

enum ErrorViewType { offline, general }

extension on ErrorViewType {
  String title(BuildContext context) {
    switch (this) {
      case ErrorViewType.offline:
        return context.l10n.noConnection_errorView_title;
      default:
        return context.l10n.common_error_title;
    }
  }

  String content(BuildContext context) {
    switch (this) {
      case ErrorViewType.offline:
        return context.l10n.noConnection_errorView_body;
      default:
        return context.l10n.common_error_body;
    }
  }

  String action(BuildContext context) {
    switch (this) {
      default:
        return context.l10n.common_tryAgain;
    }
  }
}
