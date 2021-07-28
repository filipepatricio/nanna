import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class HeroEmptyRouterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AutoRouter(
      navigatorObservers: () => <NavigatorObserver>[
        HeroController(),
      ],
    );
  }
}
