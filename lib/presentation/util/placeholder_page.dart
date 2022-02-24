import 'package:flutter/material.dart';

class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({
    required this.child,
    Key? key,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
