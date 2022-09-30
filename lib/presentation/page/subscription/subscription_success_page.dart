import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/filled_button.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/modal_bottom_sheet.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

class SubscriptionSuccessPage extends HookWidget {
  const SubscriptionSuccessPage({
    required this.trialMode,
    Key? key,
  }) : super(key: key);

  final bool trialMode;

  @override
  Widget build(BuildContext context) {
    final snackbarController = useMemoized(() => SnackbarController());

    return ModalBottomSheet(
      snackbarController: snackbarController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            AppVectorGraphics.happySun,
            height: AppDimens.c,
          ),
          const SizedBox(height: AppDimens.l),
          InformedMarkdownBody(
            markdown: (trialMode
                    ? LocaleKeys.subscription_thanksForStartingTrial
                    : LocaleKeys.subscription_thanksForSubscribing)
                .tr(),
            textAlignment: TextAlign.center,
            baseTextStyle: AppTypography.h1MediumLora,
          ),
          const SizedBox(height: AppDimens.s),
          Text(
            LocaleKeys.subscription_everythingIsReady.tr(),
            textAlign: TextAlign.center,
            style: AppTypography.b2Medium,
          ),
          const SizedBox(height: AppDimens.l),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              text: LocaleKeys.subscription_startReading.tr(),
              textColor: AppColors.white,
              fillColor: AppColors.charcoal,
              onTap: context.popRoute,
            ),
          ),
          const SizedBox(height: AppDimens.xxxl),
        ],
      ),
    );
  }
}
