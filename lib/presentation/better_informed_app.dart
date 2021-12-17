import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/routing/observers/main_navigation_observer.dart';
import 'package:better_informed_mobile/presentation/style/app_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class BetterInformedApp extends HookWidget {
  final MainRouter mainRouter;

  const BetterInformedApp({required this.mainRouter, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'InformedApp',
      debugShowCheckedModeBanner: !kIsTest,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      routeInformationParser: mainRouter.defaultRouteParser(),
      routerDelegate: mainRouter.delegate(
        navigatorObservers: () => [MainNavigationObserver()],
      ),
      theme: AppTheme.mainTheme,
    );
  }
}
