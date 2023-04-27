import 'package:flutter/material.dart';

class RestartAppWidget extends StatefulWidget {
  const RestartAppWidget({required this.child});

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<RestartAppWidgetState>()?._restartApp();
  }

  @override
  RestartAppWidgetState createState() => RestartAppWidgetState();
}

class RestartAppWidgetState extends State<RestartAppWidget> {
  Key key = UniqueKey();

  void _restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}
