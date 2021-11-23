import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/page_view_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const appBarHeight = kToolbarHeight + AppDimens.s;

class HowDoWeCurateContentPage extends HookWidget {
  const HowDoWeCurateContentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NoScrollGlow(
        child: CustomScrollView(
          shrinkWrap: true,
          slivers: [
            const _ActionsBar(),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: AppDimens.l),
                        Text(
                          LocaleKeys.topic_howDoWeCurateContent_title.tr(),
                          softWrap: true,
                          style: AppTypography.h1Bold,
                        ),
                        const SizedBox(height: AppDimens.l),
                        Text(
                          LocaleKeys.topic_howDoWeCurateContent_text.tr(),
                          softWrap: true,
                          style: AppTypography.bodyText,
                        ),
                        const SizedBox(height: AppDimens.xxl),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionsBar extends HookWidget {
  const _ActionsBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      automaticallyImplyLeading: false,
      toolbarHeight: appBarHeight,
      elevation: 0,
      backgroundColor: AppColors.background,
      leading: Padding(
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
