import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:flutter/material.dart';

class InformedAnimatedSwitcher extends StatelessWidget {
  const InformedAnimatedSwitcher({
    required this.child,
    this.duration = const Duration(milliseconds: 250),
    Key? key,
  }) : super(key: key);

  final Widget child;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return kIsTest
        ? child
        : AnimatedSwitcher(
            duration: duration,
            child: child,
          );
  }
}
