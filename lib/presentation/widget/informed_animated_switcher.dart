import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:flutter/material.dart';

class InformedAnimatedSwitcher extends StatelessWidget {
  const InformedAnimatedSwitcher({
    required this.child,
    Key? key,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return kIsTest
        ? child
        : AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: child,
          );
  }
}
