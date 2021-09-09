import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/my_reads_tab/my_reads_list_item.dart';
import 'package:better_informed_mobile/presentation/page/my_reads_tab/my_reads_page_cubit.dart';
import 'package:better_informed_mobile/presentation/page/reading_banner/reading_banner_wrapper.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

const _topMargin = 80.0;

class MyReadsPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<MyReadsPageCubit>();
    final state = useCubitBuilder(cubit);
    useEffect(
      () {
        cubit.initialize();
      },
      [cubit],
    );

    return ReadingBannerWrapper(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: _topMargin),
            const _MyReadsHeader(),
            const SizedBox(height: AppDimens.xl),
            state.maybeMap(
              initialLoading: (_) => const Loader(),
              idle: (state) => const _Idle(),
              orElse: () => const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}

class _MyReadsHeader extends StatelessWidget {
  const _MyReadsHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          LocaleKeys.main_myReadsTab.tr(),
          style: AppTypography.h0Bold,
        ),
        GestureDetector(
          onTap: () => AutoRouter.of(context).push(const SettingsMainPageRoute()),
          child: SvgPicture.asset(
            AppVectorGraphics.settings,
            width: AppDimens.ml,
            height: AppDimens.ml,
            color: Colors.black,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}

class _Idle extends StatelessWidget {
  const _Idle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('5 items', style: AppTypography.b1Medium),
          const SizedBox(height: AppDimens.s),
          Container(height: 1, color: AppColors.grey),
          const SizedBox(height: AppDimens.l),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      MyReadsListItem(),
                      Container(height: 1, color: AppColors.grey),
                      const SizedBox(height: AppDimens.l),
                      MyReadsListItem(),
                      Container(height: 1, color: AppColors.grey),
                      const SizedBox(height: AppDimens.l),
                      MyReadsListItem(),
                      const SizedBox(height: AppDimens.l),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
