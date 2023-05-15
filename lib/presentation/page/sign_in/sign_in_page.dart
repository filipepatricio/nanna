import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/sign_in/magic_link_view.dart';
import 'package:better_informed_mobile/presentation/page/sign_in/sign_in_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/sign_in/sign_in_page_state.dt.dart';
import 'package:better_informed_mobile/presentation/page/subscription/widgets/subscription_benefits.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/filled_button.dart';
import 'package:better_informed_mobile/presentation/widget/informed_dialog.dart';
import 'package:better_informed_mobile/presentation/widget/informed_svg.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/modal_bottom_sheet.dart';
import 'package:better_informed_mobile/presentation/widget/physics/platform_scroll_physics.dart';
import 'package:better_informed_mobile/presentation/widget/provider_sign_in_button/sign_in_with_apple_button.dart';
import 'package:better_informed_mobile/presentation/widget/provider_sign_in_button/sign_in_with_google_button.dart';
import 'package:better_informed_mobile/presentation/widget/provider_sign_in_button/sign_in_with_linkedin_button.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_message.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

part 'widgets/email_input.dart';
part 'widgets/sign_in_idle_view.dart';
part 'widgets/sign_in_terms_view.dart';

final _emailInputKey = GlobalKey();

class SignInPage extends HookWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late bool isModal;
    final cubit = useCubit<SignInPageCubit>();
    final state = useCubitBuilder(cubit);
    final emailController = useTextEditingController();
    final snackbarController = useMemoized(() => SnackbarController());
    final shouldRestorePurchase = useValueNotifier(false);

    void showSnackbar(String message) => snackbarController.showMessage(
          SnackbarMessage.simple(
            message: message,
            type: SnackbarMessageType.error,
          ),
        );

    useOnAppLifecycleStateChange((previous, current) {
      if (current == AppLifecycleState.resumed) {
        if (current != previous) cubit.cancelLinkedInSignIn();

        if (shouldRestorePurchase.value) {
          cubit.restorePurchase();
          shouldRestorePurchase.value = false;
        }
      }
    });

    useCubitListener<SignInPageCubit, SignInPageState>(cubit, (cubit, state, context) {
      state.whenOrNull(
        success: context.replaceToMain,
        successGuest: context.resetToEntry,
        restoringPurchase: () => InformedDialog.showRestorePurchase(context),
        redeemingCode: () => shouldRestorePurchase.value = true,
        unauthorizedError: () => showSnackbar(context.l10n.signIn_unauthorized),
        generalError: () => showSnackbar(context.l10n.common_generalError),
      );
    });

    useEffect(
      () {
        cubit.initialize();
      },
      [cubit],
    );

    useEffect(() {
      isModal = context.isModal;
    });

    return _ConditionalModalWrapper(
      wrap: isModal,
      child: Scaffold(
        appBar: context.router.canPop()
            ? null
            : AppBar(
                automaticallyImplyLeading: false,
                leadingWidth: AppDimens.xc,
                leading: state.mapOrNull(
                  magicLink: (_) => isModal
                      ? null
                      : IconButton(
                          icon: const InformedSvg(AppVectorGraphics.close),
                          color: Theme.of(context).iconTheme.color,
                          alignment: Alignment.center,
                          padding: EdgeInsets.zero,
                          onPressed: cubit.closeMagicLinkView,
                        ),
                ),
              ),
        body: Container(
          color: AppColors.of(context).backgroundPrimary,
          child: KeyboardVisibilityBuilder(
            builder: (context, visible) => AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: SnackbarParentView(
                controller: snackbarController,
                child: state.maybeMap(
                  processing: (_) => const Padding(
                    padding: EdgeInsets.only(bottom: kToolbarHeight * 2),
                    child: LoaderLogo(),
                  ),
                  processingLinkedIn: (_) => const Padding(
                    padding: EdgeInsets.only(bottom: kToolbarHeight * 2),
                    child: LoaderLogo(),
                  ),
                  magicLink: (state) => MagicLinkContent(email: state.email),
                  idle: (state) => _SignInIdleView(
                    cubit: cubit,
                    isModal: isModal,
                    isEmailValid: state.emailCorrect,
                    keyboardVisible: visible,
                    emailController: emailController,
                  ),
                  orElse: SizedBox.shrink,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ConditionalModalWrapper extends StatelessWidget {
  const _ConditionalModalWrapper({
    required this.wrap,
    required this.child,
  });

  final bool wrap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return wrap ? ModalBottomSheet(child: child) : child;
  }
}

extension on BuildContext {
  bool get isModal => router.topPage?.name == SignInPageModal.name;
}
