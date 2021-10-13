import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/my_reads/data/my_reads_content.dart';
import 'package:better_informed_mobile/domain/my_reads/data/my_reads_item.dart';
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
import 'package:flutter/services.dart';
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

    return Material(
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: ReadingBannerWrapper(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: _topMargin),
              const _MyReadsHeader(),
              const SizedBox(height: AppDimens.m),
              Expanded(
                child: state.maybeMap(
                  initialLoading: (_) => const Loader(),
                  idle: (state) => _Idle(content: state.content),
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

class _MyReadsHeader extends StatelessWidget {
  const _MyReadsHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: AppDimens.l),
        Text(
          LocaleKeys.main_myReadsTab.tr(),
          style: AppTypography.h0Bold,
        ),
        const Spacer(),
        IconButton(
          onPressed: () => AutoRouter.of(context).push(const SettingsMainPageRoute()),
          icon: SvgPicture.asset(
            AppVectorGraphics.settings,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(width: AppDimens.l),
      ],
    );
  }
}

class _Idle extends StatelessWidget {
  final MyReadsContent content;

  const _Idle({
    required this.content,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate(
            [
              const SizedBox(height: AppDimens.m),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
                child: _ItemsCountHeader(itemsCount: content.itemsCount),
              ),
              const SizedBox(height: AppDimens.s),
            ],
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => _ItemWithDivider(item: content.items[index]),
            childCount: content.itemsCount,
          ),
        ),
      ],
    );
  }
}

class _ItemsCountHeader extends StatelessWidget {
  final int itemsCount;

  const _ItemsCountHeader({
    required this.itemsCount,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      LocaleKeys.myReads_itemsCount.plural(itemsCount),
      style: AppTypography.b1Medium,
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: AppColors.grey);
  }
}

class _ItemWithDivider extends StatelessWidget {
  final MyReadsItem item;

  const _ItemWithDivider({
    required this.item,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _Divider(),
          const SizedBox(height: AppDimens.l),
          MyReadsListItem(item: item),
          const SizedBox(height: AppDimens.l),
        ],
      ),
    );
  }
}
