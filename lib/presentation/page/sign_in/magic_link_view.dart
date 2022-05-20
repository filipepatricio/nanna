import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MagicLinkContent extends StatelessWidget {
  const MagicLinkContent({
    required this.email,
    Key? key,
  }) : super(key: key);

  final String email;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppDimens.m),
            Align(
              alignment: Alignment.centerLeft,
              child: SvgPicture.asset(
                AppVectorGraphics.informedLogoDark,
                width: AppDimens.logoWidth,
                height: AppDimens.logoHeight,
              ),
            ),
            const Spacer(),
            Center(
              child: SvgPicture.asset(AppVectorGraphics.mail),
            ),
            const SizedBox(height: AppDimens.xl),
            Center(
              child: InformedMarkdownBody(
                markdown: LocaleKeys.signIn_header_magicLinkOne.tr(),
                baseTextStyle: AppTypography.h2Regular.copyWith(
                  height: 1.4,
                  letterSpacing: 0.15,
                ),
              ),
            ),
            Center(
              child: InformedMarkdownBody(
                markdown: LocaleKeys.signIn_header_magicLinkTwo.tr(args: [email]),
                baseTextStyle: AppTypography.h2Regular.copyWith(
                  height: 1.4,
                  letterSpacing: 0.15,
                ),
                maxLines: 3,
                textAlignment: TextAlign.center,
              ),
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
