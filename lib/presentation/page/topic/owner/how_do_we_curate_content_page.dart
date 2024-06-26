import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/padding_tap_widget.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/informed_svg.dart';
import 'package:better_informed_mobile/presentation/widget/physics/platform_scroll_physics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class HowDoWeCurateContentPage extends HookWidget {
  const HowDoWeCurateContentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppDimens.m)),
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            actions: [
              PaddingTapWidget(
                alignment: AlignmentDirectional.center,
                onTap: () => context.popRoute(),
                tapPadding: const EdgeInsets.all(AppDimens.l),
                child: const InformedSvg(
                  AppVectorGraphics.close,
                  fit: BoxFit.scaleDown,
                ),
              ),
            ],
          ),
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: ListView(
                  physics: getPlatformScrollPhysics(),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppDimens.pageHorizontalMargin),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: AppDimens.m),
                          Text(
                            context.l10n.topic_howWeCurateContent_title,
                            softWrap: true,
                            style: AppTypography.h0Medium,
                          ),
                          const SizedBox(height: AppDimens.m),
                          InformedMarkdownBody(
                            markdown: context.l10n.topic_howWeCurateContent_text,
                            baseTextStyle: AppTypography.articleText.copyWith(
                              height: 1.5,
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
