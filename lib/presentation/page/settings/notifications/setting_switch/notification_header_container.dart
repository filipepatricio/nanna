import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:flutter/material.dart';

class NotificationHeaderContainer extends StatelessWidget {
  const NotificationHeaderContainer({
    required this.startWidget,
    required this.trailingChildren,
    Key? key,
  }) : super(key: key);

  final List<Widget> trailingChildren;
  final Widget startWidget;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: startWidget,
        ),
        Expanded(
          flex: 2,
          child: _BaseRightRow(children: trailingChildren),
        ),
      ],
    );
  }
}

class _BaseRightRow extends StatelessWidget {
  const _BaseRightRow({
    required this.children,
    Key? key,
  }) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: children.map((e) => SizedBox(width: AppDimens.xxl, child: e)).toList(),
    );
  }
}
