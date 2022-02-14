import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/sign_in/no_beta_access/no_beta_access_page_cubit.dart';
import 'package:better_informed_mobile/presentation/page/sign_in/no_beta_access/no_beta_access_page_state.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/in_app_browser.dart';
import 'package:better_informed_mobile/presentation/widget/filled_button.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_message.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

class NoBetaAccessPage extends HookWidget {
  const NoBetaAccessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<NoBetaAccessPageCubit>();
    final snackbarController = useMemoized(() => SnackbarController());

    useCubitListener<NoBetaAccessPageCubit, NoBetaAccessPageState>(
      cubit,
      (cubit, state, context) {
        state.mapOrNull(
          emailCopied: (_) {
            snackbarController.showMessage(
              SnackbarMessage.simple(
                message: tr(LocaleKeys.noBetaAccessPage_emailCopied),
                type: SnackbarMessageType.positive,
              ),
            );
          },
          browserError: (state) {
            showBrowserError(state.link, snackbarController);
          },
        );
      },
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          iconSize: AppDimens.backArrowSize,
          color: AppColors.darkGreyBackground,
          onPressed: () => AutoRouter.of(context).pop(),
        ),
      ),
      backgroundColor: AppColors.rose,
      body: SafeArea(
        child: SnackbarParentView(
          controller: snackbarController,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 3,
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: SvgPicture.asset(
                            AppVectorGraphics.betaAccess,
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: AppDimens.l),
                            Text(
                              tr(LocaleKeys.noBetaAccessPage_headline),
                              style: AppTypography.h0Beta,
                            ),
                            const SizedBox(height: AppDimens.m),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: tr(LocaleKeys.noBetaAccessPage_infoParts_0),
                                    style: AppTypography.h4Normal,
                                  ),
                                  TextSpan(
                                    text: tr(LocaleKeys.noBetaAccessPage_infoParts_1),
                                    style: AppTypography.h4Normal.copyWith(
                                      color: AppColors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        cubit.sendAccessEmail(
                                          tr(LocaleKeys.noBetaAccessPage_email_subject),
                                          tr(LocaleKeys.noBetaAccessPage_email_body),
                                        );
                                      },
                                  ),
                                  TextSpan(
                                    text: tr(LocaleKeys.noBetaAccessPage_infoParts_2),
                                    style: AppTypography.h4Normal,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimens.m),
                FilledButton(
                  text: tr(LocaleKeys.noBetaAccessPage_waitlistAction),
                  fillColor: AppColors.darkGreyBackground,
                  textColor: AppColors.white,
                  onTap: () => cubit.openWaitlist(),
                ),
                const SizedBox(height: AppDimens.c),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
