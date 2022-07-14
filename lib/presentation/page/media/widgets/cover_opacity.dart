import 'package:flutter/material.dart';

class CoverOpacity extends StatelessWidget {
  const CoverOpacity({
    required this.visited,
    required this.child,
    super.key,
  });

  final bool visited;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: visited ? 0.30 : 1,
      child: child,
    );
  }
}
