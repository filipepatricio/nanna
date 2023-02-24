import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/settings/subscription/subscription_card/subscription_card_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/settings/subscription/subscription_card/subscription_card_state.dt.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/informed_svg.dart';
import 'package:better_informed_mobile/presentation/widget/loading_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

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
          color: AppColors.of(context).blackWhiteSecondary,
          borderRadius: const BorderRadius.all(
            Radius.circular(AppDimens.modalRadius),
          ),
          border: Border.all(
            color: AppColors.of(context).borderPrimary,
          ),
        ),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 100),
          child: state.map(
            loading: (_) => const _LoadingContent(),
            free: (data) => _IdleContent(
              typeLabel: context.l10n.subscription_free,
              callToActionLabel: Text(
                context.l10n.subscription_goPremium,
                style: AppTypography.subH1Medium.copyWith(decoration: TextDecoration.underline),
              ),
            ),
            trial: (data) => _IdleContent(
              typeLabel: context.l10n.subscription_trial,
              callToActionLabel: Text(
                context.l10n.subscription_endsIn(
                  context.l10n.date_day(data.remainingDays),
                ),
                style: AppTypography.subH1Medium,
              ),
            ),
            premium: (data) => _IdleContent(
              typeLabel: context.l10n.subscription_premium,
              callToActionLabel: Text(
                context.l10n.subscription_membership,
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
      children: const [
        LoadingShimmer.defaultColor(
          child: ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(AppDimens.s),
            ),
            child: InformedSvg(
              AppVectorGraphics.informedLogoGreen,
              colored: false,
              height: AppDimens.xxxl,
            ),
          ),
        ),
        SizedBox(width: AppDimens.m),
        Expanded(
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
    required this.typeLabel,
    required this.callToActionLabel,
    Key? key,
  }) : super(key: key);

  final String typeLabel;
  final Widget callToActionLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(AppDimens.modalRadius),
          ),
          child: InformedSvg(
            AppVectorGraphics.informedLogoGreen,
            colored: false,
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
