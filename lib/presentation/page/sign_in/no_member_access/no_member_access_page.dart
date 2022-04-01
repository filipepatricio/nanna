import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/auth/data/sign_in_credentials.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/sign_in/no_member_access/no_member_access_page_cubit.dart';
import 'package:better_informed_mobile/presentation/page/sign_in/no_member_access/no_member_access_page_state.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/in_app_browser.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/physics/platform_scroll_physics.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_message.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

class NoMemberAccessPage extends HookWidget {
  final SignInCredentials credentials;

  const NoMemberAccessPage({
    required this.credentials,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<NoMemberAccessPageCubit>();
    final state = useCubitBuilder(cubit);
    final snackbarController = useMemoized(() => SnackbarController());
    final inviteCodeController = useTextEditingController();

    useEffect(
      () {
        cubit.initialize(credentials);
      },
      [cubit],
    );

    useCubitListener<NoMemberAccessPageCubit, NoMemberAccessPageState>(
      cubit,
      (cubit, state, context) {
        state.mapOrNull(
          emailCopied: (_) {
            snackbarController.showMessage(
              SnackbarMessage.simple(
                message: LocaleKeys.noMemberAccessPage_emailCopied.tr(),
                type: SnackbarMessageType.positive,
              ),
            );
          },
          success: (state) => context.router.replaceAll(
            [
              if (!state.isOnboardingSeen) const OnboardingPageRoute() else const MainPageRoute(),
            ],
          ),
          noMemberAccess: (state) {
            snackbarController.showMessage(
              SnackbarMessage.simple(
                message: LocaleKeys.noMemberAccessPage_invalidCode.tr(),
                type: SnackbarMessageType.negative,
              ),
            );
          },
          generalError: (_) {
            snackbarController.showMessage(
              SnackbarMessage.simple(
                message: LocaleKeys.common_generalError.tr(),
                type: SnackbarMessageType.negative,
              ),
            );
          },
          browserError: (state) {
            showBrowserError(state.link, snackbarController);
          },
        );
      },
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.rose,
        body: SafeArea(
          child: SnackbarParentView(
            controller: snackbarController,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    alignment: Alignment.center,
                    child: SingleChildScrollView(
                      physics: getPlatformScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: kToolbarHeight),
                          SvgPicture.asset(
                            AppVectorGraphics.memberAccess,
                          ),
                          const SizedBox(height: AppDimens.l),
                          Text(
                            LocaleKeys.noMemberAccessPage_headline.tr(),
                            style: AppTypography.h0Beta(context),
                          ),
                          const SizedBox(height: AppDimens.m),
                          Text(
                            LocaleKeys.noMemberAccessPage_yourInviteCode.tr(),
                            style: AppTypography.b3Regular,
                          ),
                          const SizedBox(height: AppDimens.s),
                          Row(
                            children: [
                              Expanded(
                                child: _InviteCodeInput(
                                  controller: inviteCodeController,
                                  cubit: cubit,
                                ),
                              ),
                              state.maybeMap(
                                processing: (_) => const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: AppDimens.m),
                                  child: Loader(strokeWidth: 3.0),
                                ),
                                orElse: () => const SizedBox(height: 0, width: 0),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppDimens.xl),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: LocaleKeys.noMemberAccessPage_infoParts_0.tr(),
                                  style: AppTypography.b2Regular,
                                ),
                                TextSpan(
                                  text: LocaleKeys.noMemberAccessPage_infoParts_1.tr(),
                                  style: AppTypography.b2Regular.copyWith(
                                    color: AppColors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => cubit.sendAccessEmail(
                                          LocaleKeys.noMemberAccessPage_email_subject.tr(),
                                          LocaleKeys.noMemberAccessPage_email_body.tr(),
                                        ),
                                ),
                                TextSpan(
                                  text: LocaleKeys.noMemberAccessPage_infoParts_2.tr(),
                                  style: AppTypography.b2Regular,
                                ),
                                TextSpan(
                                  text: LocaleKeys.noMemberAccessPage_infoParts_3.tr(),
                                  style: AppTypography.b2Regular.copyWith(
                                    color: AppColors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()..onTap = () => cubit.openWaitlist(),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppDimens.xxxl),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  top: AppDimens.s,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    iconSize: AppDimens.l,
                    color: AppColors.darkGreyBackground,
                    onPressed: () => AutoRouter.of(context).pop(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final _inviteCodeInputKey = GlobalKey();

class _InviteCodeInput extends StatelessWidget {
  final TextEditingController controller;
  final NoMemberAccessPageCubit cubit;

  const _InviteCodeInput({
    required this.controller,
    required this.cubit,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: _inviteCodeInputKey,
      controller: controller,
      style: AppTypography.b2Regular.copyWith(
        height: 2.02,
        letterSpacing: 0.15,
      ),
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintStyle: AppTypography.b2Regular.copyWith(
          height: 2.02,
          letterSpacing: 0.15,
          color: AppColors.black40,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 1, color: AppColors.black),
          borderRadius: BorderRadius.circular(AppDimens.sl),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 1, color: AppColors.black),
          borderRadius: BorderRadius.circular(AppDimens.sl),
        ),
        contentPadding: const EdgeInsets.only(left: AppDimens.m),
      ),
      maxLines: 1,
      textAlignVertical: TextAlignVertical.center,
      textInputAction: TextInputAction.done,
      textCapitalization: TextCapitalization.characters,
      onSubmitted: (value) => value.isNotEmpty ? cubit.signInWithInviteCode(value) : null,
    );
  }
}
