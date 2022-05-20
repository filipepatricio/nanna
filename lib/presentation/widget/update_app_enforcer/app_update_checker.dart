import 'package:better_informed_mobile/core/util/app_link.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/open_web_button.dart';
import 'package:better_informed_mobile/presentation/widget/update_app_enforcer/app_update_checker_cubit.di.dart';
import 'package:better_informed_mobile/presentation/widget/update_app_enforcer/app_update_checker_state.dt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppUpdateChecker extends HookWidget {
  const AppUpdateChecker({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<AppUpdateCheckerCubit>();

    useEffect(
      () {
        cubit.initialize();
      },
      [cubit],
    );

    useCubitListener<AppUpdateCheckerCubit, AppUpdateCheckerState>(
      cubit,
      (cubit, state, context) {
        state.maybeMap(
          needsUpdate: (state) => _AppUpdateDialog.show(context, state.availableVersion),
          orElse: () {},
        );
      },
    );

    useOnAppLifecycleStateChange(
      (previous, current) {
        if (current == AppLifecycleState.resumed) {
          cubit.shouldUpdate();
        }
      },
    );

    return child;
  }
}

class _AppUpdateDialog extends HookWidget {
  const _AppUpdateDialog({
    required this.availableVersion,
    Key? key,
  }) : super(key: key);

  final String? availableVersion;

  static Future<void> show(BuildContext context, String? availableVersion) {
    return showDialog(
      context: context,
      useRootNavigator: true,
      barrierDismissible: false,
      builder: (BuildContext context) => _AppUpdateDialog(
        availableVersion: availableVersion,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<AppUpdateCheckerCubit>();

    return WillPopScope(
      onWillPop: () async => !(await cubit.shouldUpdate()),
      child: SimpleDialog(
        insetPadding: const EdgeInsets.symmetric(
          horizontal: AppDimens.l,
          vertical: AppDimens.l,
        ),
        contentPadding: const EdgeInsets.fromLTRB(
          AppDimens.l,
          AppDimens.xl,
          AppDimens.l,
          AppDimens.xxl,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                AppVectorGraphics.megaphone,
                width: AppDimens.onboardingIconSize,
                height: AppDimens.onboardingIconSize,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: AppDimens.l),
              Text(
                LocaleKeys.update_title.tr(),
                style: AppTypography.h4Bold,
              ),
              const SizedBox(height: AppDimens.m),
              Text(
                LocaleKeys.update_body.tr(),
                style: AppTypography.b2Regular,
              ),
              const SizedBox(height: AppDimens.l),
              if (availableVersion != null) ...[
                Text(
                  LocaleKeys.update_versionAvailable.tr(args: [availableVersion!]),
                  style: AppTypography.b2Regular.copyWith(color: AppColors.textGrey),
                ),
                const SizedBox(height: AppDimens.l),
              ],
              Center(
                child: OpenWebButton(
                  withIcon: false,
                  url: platformStoreLink,
                  buttonLabel: LocaleKeys.update_button.tr(),
                  padding: const EdgeInsets.symmetric(horizontal: AppDimens.c),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
