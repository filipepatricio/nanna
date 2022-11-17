import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/expand_tap_area/expand_tap_area.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/physics/platform_scroll_physics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HowDoWeCurateContentPage extends HookWidget {
  const HowDoWeCurateContentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppDimens.m)),
        child: Scaffold(
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _ActionsBar(),
              Expanded(
                child: ListView(
                  physics: getPlatformScrollPhysics(),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppDimens.pageHorizontalMargin),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LocaleKeys.topic_howWeCurateContent_title.tr(),
                            softWrap: true,
                            style: AppTypography.h0Medium,
                          ),
                          const SizedBox(height: AppDimens.l),
                          InformedMarkdownBody(
                            markdown: LocaleKeys.topic_howWeCurateContent_text.tr(),
                            baseTextStyle: AppTypography.articleText.copyWith(
                              height: 1.75,
                            ),
                            pPadding: const EdgeInsets.only(top: AppDimens.m),
                          ),
                          const SizedBox(height: AppDimens.xxl),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionsBar extends HookWidget {
  const _ActionsBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight + AppDimens.m,
      color: AppColors.background,
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: AppDimens.pageHorizontalMargin),
        child: ExpandTapWidget(
          onTap: () => context.popRoute(),
          tapPadding: const EdgeInsets.all(AppDimens.s),
          child: SvgPicture.asset(
            AppVectorGraphics.close,
            fit: BoxFit.scaleDown,
          ),
        ),
      ),
    );
  }
}
