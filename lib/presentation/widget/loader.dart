import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({Key? key, this.color}) : super(key: key);
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        value: kIsTest ? .5 : null,
        valueColor: color != null ? AlwaysStoppedAnimation(color) : null,
      ),
    );
  }
}
