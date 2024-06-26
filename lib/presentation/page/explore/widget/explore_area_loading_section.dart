import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
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
    final row = Row(
      children: const [
        _Pill(),
        SizedBox(width: AppDimens.m),
        _Pill(),
        SizedBox(width: AppDimens.m),
        _Pill(),
        SizedBox(width: AppDimens.m),
        _Pill(),
      ],
    );

    return SizedBox(
      height: AppDimens.explorePillHeight(context),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.pageHorizontalMargin),
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: row,
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill();

  @override
  Widget build(BuildContext context) {
    return LoadingShimmer.defaultColor(
      width: AppDimens.xxxc * 1.5,
      height: AppDimens.explorePillHeight(context),
      radius: AppDimens.pillRadius,
    );
  }
}

class _StreamArea extends StatelessWidget {
  const _StreamArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width * AppDimens.exploreTopicCellSizeFactor;

    return SizedBox(
      height: size,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.pageHorizontalMargin),
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
    return LoadingShimmer.defaultColor(
      width: size,
      height: size * 2,
      radius: AppDimens.defaultRadius,
    );
  }
}
