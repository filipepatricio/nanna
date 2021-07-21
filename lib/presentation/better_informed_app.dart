import 'package:better_informed_mobile/exports.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class BetterInformedApp extends StatelessWidget {
  final MainRouter mainRouter;

  const BetterInformedApp({required this.mainRouter, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'InformedApp',
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      routeInformationParser: mainRouter.defaultRouteParser(),
      routerDelegate: mainRouter.delegate(),
    );
  }
}
