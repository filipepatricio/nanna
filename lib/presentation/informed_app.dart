import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/routing/observers/main_navigation_observer.di.dart';
import 'package:better_informed_mobile/presentation/style/app_raster_graphics.dart';
import 'package:better_informed_mobile/presentation/style/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class InformedApp extends HookWidget {
  const InformedApp({
    required this.mainRouter,
    required this.getIt,
    Key? key,
  }) : super(key: key);

  final MainRouter mainRouter;
  final GetIt getIt;

  @override
  Widget build(BuildContext context) {
    if (kIsTest) {
      return Provider.value(
        value: getIt,
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routeInformationParser: mainRouter.defaultRouteParser(),
          routerDelegate: mainRouter.delegate(),
          theme: AppTheme.mainTheme,
        ),
      );
    }

    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => _precacheImages(context),
        );
      },
      [],
    );

    return Provider.value(
      value: getIt,
      child: MaterialApp.router(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        routeInformationParser: mainRouter.defaultRouteParser(),
        routerDelegate: mainRouter.delegate(
          navigatorObservers: () => [
            // To solve issue with Hero animations in tab navigation - https://github.com/Milad-Akarie/auto_route_library/issues/418#issuecomment-997704836
            HeroController(),
            getIt<MainNavigationObserver>(),
            SentryNavigatorObserver(),
          ],
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
      ),
    );
  }
}

void _precacheImages(BuildContext context) {
  precacheImage(
    const AssetImage(
      AppRasterGraphics.shareStickerBackgroundGreen,
    ),
    context,
  );
  precacheImage(
    const AssetImage(
      AppRasterGraphics.shareStickerBackgroundPeach,
    ),
    context,
  );
}
