import 'package:better_informed_mobile/presentation/page/settings/notifications/daily_brief_badge_switch/daily_brief_badge_switch_cubit.di.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/informed_svg.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DailyBriefBadgeSwitchContainer extends HookWidget {
  const DailyBriefBadgeSwitchContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<DailyBriefBadgeSwitchCubit>();
    final state = useCubitBuilder(cubit);

    useEffect(
      () {
        cubit.initialize();
      },
      [cubit],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Badges',
          style: AppTypography.subH1Bold.copyWith(
            color: AppColors.of(context).textTertiary,
          ),
        ),
        const SizedBox(height: AppDimens.m),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Indicate the number of new items in Today',
                    style: AppTypography.b2Medium,
                  ),
                  const SizedBox(height: AppDimens.s),
                  state.maybeMap(
                    free: (state) => Row(
                      children: [
                        InformedSvg(
                          AppVectorGraphics.locker,
                          color: Theme.of(context).iconTheme.color,
                          height: AppDimens.s + AppDimens.xxs,
                        ),
                        const SizedBox(width: AppDimens.xs),
                        Text(
                          'Unlock with Premium',
                          style: AppTypography.sansTextNanoLausanne
                              .copyWith(height: 1, color: AppColors.of(context).textSecondary),
                        ),
                      ],
                    ),
                    orElse: SizedBox.shrink,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppDimens.s),
            state.maybeMap(
              free: (state) => Switch.adaptive(
                // This bool value toggles the switch.
                value: state.shouldShowBadge,
                activeColor: AppColors.of(context).switchPrimary,
                onChanged: null,
              ),
              premiumOrTrial: (state) => Switch.adaptive(
                // This bool value toggles the switch.
                value: state.shouldShowBadge,
                activeColor: AppColors.of(context).switchPrimary,
                onChanged: cubit.setShouldShowDailyBriefBadge,
              ),
              orElse: () => _Processing(),
            )
          ],
        ),
      ],
    );
  }
}

class _Processing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: AppDimens.l,
        width: AppDimens.l,
        padding: const EdgeInsets.all(AppDimens.one),
        child: Loader(
          strokeWidth: 2.0,
          color: AppColors.of(context).borderPrimary,
        ),
      ),
    );
  }
}
