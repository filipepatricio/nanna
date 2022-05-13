import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:flutter/material.dart';

class ExploreAreaHeader extends StatelessWidget {
  const ExploreAreaHeader({
    required this.title,
    this.description,
    Key? key,
  }) : super(key: key);

  final String title;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final optDescription = description;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InformedMarkdownBody(
            markdown: title,
            highlightColor: AppColors.transparent,
            baseTextStyle: AppTypography.h5ExtraBold,
          ),
          if (optDescription != null) ...[
            const SizedBox(height: AppDimens.xs),
            Text(
              optDescription,
              style: AppTypography.subH1Medium,
            ),
          ],
        ],
      ),
    );
  }
}
