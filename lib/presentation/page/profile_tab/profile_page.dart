import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/profile_tab/profile_page_cubit.dart';
import 'package:better_informed_mobile/presentation/page/reading_banner/reading_banner_wrapper.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/filled_button.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

const _feedbackEmail = 'feedback@informed.so';

class ProfilePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<ProfilePageCubit>();
    final state = useCubitBuilder(cubit);
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
          style: AppTypography.h1Bold.copyWith(color: AppColors.textPrimary),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.s),
            child: IconButton(
              onPressed: () => AutoRouter.of(context).push(const SettingsMainPageRoute()),
              icon: SvgPicture.asset(
                AppVectorGraphics.settings,
                fit: BoxFit.contain,
              ),
            ),
          )
        ],
      ),
      body: ReadingBannerWrapper(
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppDimens.m),
              Expanded(
                child: state.maybeMap(
                  initialLoading: (_) => const Loader(),
                  idle: (state) => const _Idle(),
                  orElse: () => const SizedBox(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Idle extends StatelessWidget {
  const _Idle({
    Key? key,
  }) : super(key: key);

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
            onTap: () async {
              final email = Email(
                body: LocaleKeys.profile_feedbackText.tr(),
                subject: LocaleKeys.profile_feedbackSubject.tr(),
                recipients: [_feedbackEmail],
              );

              try {
                await FlutterEmailSender.send(email);
              } catch (e, s) {
                Fimber.e('Sending feedback email failed', ex: e, stacktrace: s);
              }
            },
          ),
        ),
      ],
    );
  }
}
