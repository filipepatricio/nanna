import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({
    this.color,
    this.strokeWidth = 4.0,
    Key? key,
  }) : super(key: key);

  final Color? color;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        value: kIsTest ? .5 : null,
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation(color),
      ),
    );
  }
}
