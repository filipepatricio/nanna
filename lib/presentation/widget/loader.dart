import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({Key? key, this.color}) : super(key: key);
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: color != null ? AlwaysStoppedAnimation(color) : null,
      ),
    );
  }
}
