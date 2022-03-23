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
      localizationsDelegates: !kIsTest ? context.localizationDelegates : null,
      supportedLocales: !kIsTest ? context.supportedLocales : const [Locale('en')],
      locale: !kIsTest ? context.locale : null,
      routeInformationParser: mainRouter.defaultRouteParser(),
      routerDelegate: mainRouter.delegate(
        navigatorObservers: () => [MainNavigationObserver()],
      ),
      theme: AppTheme.mainTheme,
      builder: (context, child) {
        final mediaQueryData = MediaQuery.of(context);
        // Take the textScaleFactor from system and make
        // sure that it's no less than 1.0, but no more
        // than 1.5.
        final constrainedTextScaleFactor = mediaQueryData.textScaleFactor.clamp(1.0, 1.5);

        return MediaQuery(
          data: mediaQueryData.copyWith(textScaleFactor: constrainedTextScaleFactor),
          child: child!,
        );
      },
    );
  }
}
