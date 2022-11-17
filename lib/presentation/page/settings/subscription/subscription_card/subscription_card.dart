import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/settings/subscription/subscription_card/subscription_card_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/settings/subscription/subscription_card/subscription_card_state.dt.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/loading_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SubscriptionCard extends HookWidget {
  const SubscriptionCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<SubscriptionCardCubit>();
    final state = useCubitBuilder(cubit);

    useEffect(
      () {
        cubit.initialize();
      },
      [cubit],
    );

    return GestureDetector(
      onTap: state.getOnTap(context),
      child: Container(
        padding: const EdgeInsets.all(AppDimens.m),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(AppDimens.modalRadius),
          ),
          border: Border.all(color: AppColors.lightGrey),
        ),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 100),
          child: state.map(
            loading: (_) => const _LoadingContent(),
            free: (data) => _IdleContent(
              icon: AppVectorGraphics.informedLogoGreen,
              typeLabel: LocaleKeys.subscription_free.tr(),
              callToActionLabel: Text(
                LocaleKeys.subscription_goPremium.tr(),
                style: AppTypography.subH1Medium.copyWith(decoration: TextDecoration.underline),
              ),
            ),
            trial: (data) => _IdleContent(
              icon: AppVectorGraphics.informedLogoGreen,
              typeLabel: LocaleKeys.subscription_trial.tr(),
              callToActionLabel: Text(
                LocaleKeys.subscription_endsIn.tr(
                  args: [LocaleKeys.date_day.plural(data.remainingDays)],
                ),
                style: AppTypography.subH1Medium,
              ),
            ),
            premium: (data) => _IdleContent(
              icon: AppVectorGraphics.informedLogoGreen,
              typeLabel: LocaleKeys.subscription_premium.tr(),
              callToActionLabel: Text(
                LocaleKeys.subscription_membership.tr(),
                style: AppTypography.subH1Medium,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoadingContent extends StatelessWidget {
  const _LoadingContent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        LoadingShimmer.defaultColor(
          child: ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(AppDimens.s),
            ),
            child: SvgPicture.asset(
              AppVectorGraphics.informedLogoGreen,
              height: AppDimens.xxxl,
            ),
          ),
        ),
        const SizedBox(width: AppDimens.m),
        const Expanded(
          child: LoadingShimmer.defaultColor(
            height: 20,
            radius: AppDimens.m,
          ),
        ),
      ],
    );
  }
}

class _IdleContent extends StatelessWidget {
  const _IdleContent({
    required this.icon,
    required this.typeLabel,
    required this.callToActionLabel,
    Key? key,
  }) : super(key: key);

  final String icon;
  final String typeLabel;
  final Widget callToActionLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(AppDimens.modalRadius),
          ),
          child: SvgPicture.asset(
            icon,
            height: AppDimens.xxxl,
          ),
        ),
        const SizedBox(width: AppDimens.m),
        Text(
          typeLabel,
          style: AppTypography.h4Medium.copyWith(height: 1),
        ),
        const Spacer(),
        callToActionLabel,
        const SizedBox(width: AppDimens.xs),
        const Icon(
          Icons.arrow_forward_ios_rounded,
          size: AppDimens.m,
          color: AppColors.charcoal,
        ),
      ],
    );
  }
}

extension on SubscriptionCardState {
  VoidCallback? getOnTap(BuildContext context) {
    return mapOrNull(
      free: (_) => () => context.pushRoute(const SubscriptionPageRoute()),
      trial: (_) => () => context.pushRoute(const SettingsSubscriptionPageRoute()),
      premium: (_) => () => context.pushRoute(const SettingsSubscriptionPageRoute()),
    );
  }
}
