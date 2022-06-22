import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

typedef FlexibleWrapChildrenBuilder = List<Widget> Function(double width, double height);

class FlexibleWrapWithHorizontalScroll extends StatelessWidget {
  const FlexibleWrapWithHorizontalScroll({
    required this.childrenBuilder,
    required this.childrenRowCount,
    this.spacing = 0,
    this.childrenColumnCount = 3,
    this.horizontalPadding = AppDimens.xl,
    Key? key,
  }) : super(key: key);

  final FlexibleWrapChildrenBuilder childrenBuilder;
  final double spacing;
  final int childrenRowCount;
  final int childrenColumnCount;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return _HookWrap(
          childrenColumnCount: childrenColumnCount,
          spacing: spacing,
          childrenBuilder: childrenBuilder,
          childrenRowCount: childrenRowCount,
          constraints: constraints,
          horizontalPadding: horizontalPadding,
        );
      },
    );
  }
}

class _HookWrap extends HookWidget {
  const _HookWrap({
    required this.constraints,
    required this.spacing,
    required this.childrenBuilder,
    required this.childrenRowCount,
    required this.childrenColumnCount,
    required this.horizontalPadding,
    Key? key,
  }) : super(key: key);

  final double spacing;
  final FlexibleWrapChildrenBuilder childrenBuilder;
  final BoxConstraints constraints;
  final int childrenRowCount;
  final int childrenColumnCount;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    final flexWidth = useMemoized(
      () => ((constraints.maxWidth - (horizontalPadding * 2)) - (spacing * (childrenRowCount - 1))) / childrenRowCount,
      [constraints],
    );

    final flexHeight = useMemoized(
      () => (constraints.maxHeight - (spacing * (childrenColumnCount - 1))) / childrenColumnCount,
      [constraints],
    );

    final dividedWidgetList = useMemoized(
      () => _divideList(flexWidth, flexHeight),
      [
        childrenBuilder,
        childrenRowCount,
        childrenColumnCount,
        constraints,
      ],
    );

    final isScrollNeeded = useMemoized(
      () => dividedWidgetList.length > 1,
      [dividedWidgetList],
    );

    return ListView.builder(
      physics: isScrollNeeded ? null : const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemCount: dividedWidgetList.length,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.only(right: isScrollNeeded ? spacing : 0),
        child: Wrap(
          direction: isScrollNeeded ? Axis.vertical : Axis.horizontal,
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.start,
          runSpacing: spacing,
          spacing: spacing,
          children: dividedWidgetList[index],
        ),
      ),
    );
  }

  List<List<Widget>> _divideList(double flexWidth, double flexHeight) {
    final wrapChildrenCount = childrenColumnCount * childrenRowCount;
    final childrenList = childrenBuilder(flexWidth, flexHeight);
    final wrapCount = (childrenList.length / wrapChildrenCount).ceil();

    final List<List<Widget>> mappedList = [];

    for (var i = 0; i < wrapCount; i++) {
      final currentWrapChildren = <Widget>[];
      final isLast = (wrapCount - 1) == i;
      final currentWrapChildrenCount = isLast ? childrenList.length % wrapChildrenCount : wrapChildrenCount;

      for (var n = 0; n < currentWrapChildrenCount; n++) {
        final index = n + (i * wrapChildrenCount);
        currentWrapChildren.add(childrenList[index]);
      }

      mappedList.add(currentWrapChildren);
    }
    return mappedList;
  }
}
