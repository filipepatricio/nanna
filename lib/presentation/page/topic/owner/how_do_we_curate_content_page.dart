import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/scroll_controller_utils.dart';
import 'package:better_informed_mobile/presentation/widget/physics/platform_scroll_physics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class HowDoWeCurateContentPage extends HookWidget {
  const HowDoWeCurateContentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppDimens.m)),
        child: Scaffold(
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _ActionsBar(),
              Expanded(
                child: NoScrollGlow(
                  child: ListView(
                    physics: getPlatformScrollPhysics(),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              LocaleKeys.topic_howDoWeCurateContent_title.tr(),
                              softWrap: true,
                              style: AppTypography.h1Bold,
                            ),
                            const SizedBox(height: AppDimens.l),
                            Text(
                              LocaleKeys.topic_howDoWeCurateContent_text.tr(),
                              softWrap: true,
                              style: AppTypography.articleTextRegular.copyWith(
                                height: 1.75,
                              ),
                            ),
                            const SizedBox(height: AppDimens.xxl),
                          ],
                        ),
                      ),
                    ],
                  ),
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
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: AppDimens.ml),
        child: IconButton(
          icon: const Icon(Icons.arrow_downward_rounded),
          color: AppColors.black,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.zero,
          onPressed: () => context.popRoute(),
        ),
      ),
    );
  }
}
