import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/routing/observers/main_navigation_observer.dart';
import 'package:better_informed_mobile/presentation/style/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class InformedApp extends HookWidget {
  const InformedApp({
    required this.mainRouter,
    Key? key,
  }) : super(key: key);

  final MainRouter mainRouter;

  @override
  Widget build(BuildContext context) {
    if (kIsTest) {
      return MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routeInformationParser: mainRouter.defaultRouteParser(),
        routerDelegate: mainRouter.delegate(),
        theme: AppTheme.mainTheme,
      );
    }

    return MaterialApp.router(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
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
