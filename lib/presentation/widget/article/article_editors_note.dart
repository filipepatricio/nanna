import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/device_type.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:flutter/material.dart';

class ArticleEditorsNote extends StatelessWidget {
  final String note;

  const ArticleEditorsNote({
    required this.note,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(AppDimens.l),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InformedMarkdownBody(
            markdown: note,
            baseTextStyle: context.isSmallDevice ? AppTypography.b3RegularLora : AppTypography.b2RegularLora,
            maxLines: 7,
          ),
        ],
      ),
    );
  }
}
