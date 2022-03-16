import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/profile_tab/profile_page_cubit.dart';
import 'package:better_informed_mobile/presentation/page/profile_tab/profile_page_state.dart';
import 'package:better_informed_mobile/presentation/page/reading_banner/reading_banner_wrapper.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/filled_button.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_message.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

const _feedbackEmail = 'feedback@informed.so';

class ProfilePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<ProfilePageCubit>();
    final state = useCubitBuilder(cubit);
    final snackbarController = useMemoized(() => SnackbarController());

    useCubitListener<ProfilePageCubit, ProfilePageState>(cubit, (cubit, state, context) {
      state.mapOrNull(
        sendingEmailError: (error) {
          _showEmailErrorMessage(snackbarController);
        },
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
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        centerTitle: false,
        titleSpacing: AppDimens.l,
        title: Text(
          LocaleKeys.profile_title.tr(),
          style: AppTypography.h1Bold,
        ),
        actions: [
          IconButton(
            onPressed: () => AutoRouter.of(context).push(const SettingsMainPageRoute()),
            icon: SvgPicture.asset(
              AppVectorGraphics.gift,
              fit: BoxFit.contain,
            ),
            splashRadius: AppDimens.l,
          ),
          IconButton(
            onPressed: () => AutoRouter.of(context).push(const SettingsMainPageRoute()),
            icon: SvgPicture.asset(
              AppVectorGraphics.settings,
              fit: BoxFit.contain,
            ),
            splashRadius: AppDimens.l,
          ),
          const SizedBox(width: AppDimens.s),
        ],
      ),
      body: ReadingBannerWrapper(
        child: SnackbarParentView(
          controller: snackbarController,
          child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.dark,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppDimens.m),
                Expanded(
                  child: state.maybeMap(
                    initialLoading: (_) => const Loader(),
                    idle: (state) => _Idle(cubit: cubit),
                    orElse: () => const SizedBox(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEmailErrorMessage(SnackbarController controller) {
    controller.showMessage(
      SnackbarMessage.custom(
        message: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: LocaleKeys.profile_feedbackMailError.tr(),
                style: AppTypography.h4Normal.copyWith(color: AppColors.white),
              ),
              TextSpan(
                text: _feedbackEmail,
                style: AppTypography.h4Normal.copyWith(
                  color: AppColors.white,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    _copyEmailToClipboard(controller);
                  },
              ),
            ],
          ),
        ),
        type: SnackbarMessageType.negative,
      ),
    );
  }

  void _copyEmailToClipboard(SnackbarController controller) {
    Clipboard.setData(const ClipboardData(text: _feedbackEmail));
    controller.showMessage(
      SnackbarMessage.simple(
        message: LocaleKeys.profile_emailCopied.tr(),
        type: SnackbarMessageType.positive,
      ),
    );
  }
}

class _Idle extends StatelessWidget {
  const _Idle({
    required this.cubit,
    Key? key,
  }) : super(key: key);

  final ProfilePageCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          AppVectorGraphics.stayTuned,
        ),
        const SizedBox(height: AppDimens.m),
        Text(
          LocaleKeys.profile_stayTuned.tr(),
          style: AppTypography.h3Bold16,
        ),
        Text(
          LocaleKeys.profile_stayTunedText.tr(),
          style: AppTypography.b1Regular,
        ),
        const SizedBox(height: AppDimens.xl),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
          child: FilledButton(
            text: LocaleKeys.profile_feedbackButton.tr(),
            fillColor: AppColors.textPrimary,
            textColor: AppColors.white,
            onTap: () {
              cubit.sendFeedbackEmail(
                _feedbackEmail,
                LocaleKeys.profile_feedbackSubject.tr(),
                LocaleKeys.profile_feedbackText.tr(),
              );
            },
          ),
        ),
      ],
    );
  }
}
