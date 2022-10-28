import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ShareOptionItem extends StatelessWidget {
  const ShareOptionItem({
    required this.svg,
    required this.text,
    required this.onTap,
    super.key,
  });

  final String? svg;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final svg = this.svg;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.m),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                text,
                style: AppTypography.b2Regular,
              ),
            ),
            if (svg != null) ...[
              SvgPicture.asset(
                svg,
                width: AppDimens.l,
                height: AppDimens.l,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
