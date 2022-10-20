import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/app_config/app_urls.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/sign_in/magic_link_view.dart';
import 'package:better_informed_mobile/presentation/page/sign_in/sign_in_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/sign_in/sign_in_page_state.dt.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/in_app_browser.dart';
import 'package:better_informed_mobile/presentation/widget/filled_button.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/provider_sign_in_button/sign_in_with_linkedin_button.dart';
import 'package:better_informed_mobile/presentation/widget/provider_sign_in_button/sign_in_with_provider_view.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_message.dt.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

part 'widgets/email_input.dart';
part 'widgets/sign_in_idle_view.dart';
part 'widgets/sign_in_terms_view.dart';

final _emailInputKey = GlobalKey();
const _loadingLogo = Padding(
  padding: EdgeInsets.only(bottom: kToolbarHeight),
  child: LoaderLogo(),
);

class SignInPage extends HookWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<SignInPageCubit>();
    final state = useCubitBuilder(cubit);
    final emailController = useTextEditingController();
    final snackbarController = useMemoized(() => SnackbarController());

    void showSnackbar(String message) => snackbarController.showMessage(
          SnackbarMessage.simple(
            message: message,
            type: SnackbarMessageType.negative,
          ),
        );

    useOnAppLifecycleStateChange((previous, current) {
      if (current != previous && current == AppLifecycleState.resumed) {
        cubit.cancelLinkedInSignIn();
      }
    });

    useCubitListener<SignInPageCubit, SignInPageState>(cubit, (cubit, state, context) {
      state.maybeMap(
        success: (state) => AutoRouter.of(context).replaceAll(
          [
            if (!state.isOnboardingSeen) const OnboardingPageRoute() else const MainPageRoute(),
          ],
        ),
        unauthorizedError: (_) => showSnackbar(LocaleKeys.signIn_unauthorized.tr()),
        generalError: (_) => showSnackbar(LocaleKeys.common_generalError.tr()),
        orElse: () {},
      );
    });

    useEffect(
      () {
        cubit.initialize();
      },
      [cubit],
    );

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        leading: state.maybeMap(
          magicLink: (_) => Padding(
            padding: const EdgeInsets.only(left: AppDimens.m + AppDimens.xxs),
            child: IconButton(
              icon: const Icon(Icons.close_rounded),
              color: AppColors.textPrimary,
              highlightColor: AppColors.transparent,
              splashColor: AppColors.transparent,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.zero,
              onPressed: () {
                cubit.closeMagicLinkView();
              },
            ),
          ),
          orElse: () => const SizedBox.shrink(),
        ),
      ),
      body: Container(
        color: AppColors.background,
        child: KeyboardVisibilityBuilder(
          builder: (context, visible) => AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: SnackbarParentView(
              controller: snackbarController,
              child: state.maybeMap(
                processing: (_) => _loadingLogo,
                processingLinkedIn: (_) => _loadingLogo,
                magicLink: (state) => MagicLinkContent(email: state.email),
                idle: (state) => _SignInIdleView(
                  cubit: cubit,
                  isEmailValid: state.emailCorrect,
                  keyboardVisible: visible,
                  emailController: emailController,
                  snackbarController: snackbarController,
                ),
                orElse: () => const SizedBox.shrink(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
