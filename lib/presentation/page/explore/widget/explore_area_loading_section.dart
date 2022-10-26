import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/widget/loading_shimmer.dart';
import 'package:flutter/material.dart';

enum _ExploreLoadingViewType { pills, stream }

class ExploreLoadingView extends StatelessWidget {
  const ExploreLoadingView._(
    this._section, {
    Key? key,
  }) : super(key: key);

  const ExploreLoadingView.pills({Key? key})
      : this._(
          _ExploreLoadingViewType.pills,
          key: key,
        );

  const ExploreLoadingView.stream({Key? key})
      : this._(
          _ExploreLoadingViewType.stream,
          key: key,
        );

  final _ExploreLoadingViewType _section;

  @override
  Widget build(BuildContext context) {
    switch (_section) {
      case _ExploreLoadingViewType.pills:
        return const _PillsArea();
      case _ExploreLoadingViewType.stream:
        return const _StreamArea();
    }
  }
}

class _PillsArea extends StatelessWidget {
  const _PillsArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoadingShimmer.defaultColor(
      enabled: !kIsTest,
      child: SizedBox(
        height: AppDimens.explorePillHeight,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.pageHorizontalMargin),
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    _Pill(width: 120),
                    SizedBox(width: AppDimens.s),
                    _Pill(width: 80),
                    SizedBox(width: AppDimens.s),
                    _Pill(width: 100),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.width,
    Key? key,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimens.explorePillHeight,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimens.explorePillRadius),
        border: Border.all(
          color: AppColors.dividerGreyLight,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: AppDimens.sl,
        horizontal: AppDimens.l,
      ),
      child: SizedBox(width: width),
    );
  }
}

class _StreamArea extends StatelessWidget {
  const _StreamArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width * AppDimens.exploreTopicCellSizeFactor;

    return LoadingShimmer.defaultColor(
      enabled: !kIsTest,
      child: SizedBox(
        height: size,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          children: [
            _StreamCell(size: size),
            const SizedBox(width: AppDimens.m),
            _StreamCell(size: size),
            const SizedBox(width: AppDimens.m),
            _StreamCell(size: size),
            const SizedBox(width: AppDimens.m),
            _StreamCell(size: size),
          ],
        ),
      ),
    );
  }
}

class _StreamCell extends StatelessWidget {
  const _StreamCell({
    required this.size,
    Key? key,
  }) : super(key: key);

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size * 2,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(AppDimens.m),
        ),
      ),
    );
  }
}
