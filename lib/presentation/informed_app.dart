import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/restart_app_widget.dart';
import 'package:better_informed_mobile/presentation/routing/observers/main_navigation_observer.di.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/informed_theme.dart';
import 'package:better_informed_mobile/presentation/util/device_type.dart';
import 'package:better_informed_mobile/presentation/util/scroll_controller_utils.dart';
import 'package:better_informed_mobile/presentation/widget/app_connectivity_checker/app_connectivity_checker.dart';
import 'package:better_informed_mobile/presentation/widget/image_precaching_view/image_precaching_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_it/get_it.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class InformedApp extends HookWidget {
  const InformedApp({
    required this.getIt,
    this.themeMode,
    this.mainRouter,
    Key? key,
  }) : super(key: key);

  final GetIt getIt;
  final MainRouter? mainRouter;
  final AdaptiveThemeMode? themeMode;

  Widget responsiveBuilder(MediaQueryData mediaQuery, Widget? child) => ResponsiveWrapper.builder(
        // Override textScaleFactor from device settings
        child!,
        mediaQueryData: mediaQuery.copyWith(
          textScaleFactor: mediaQuery.textScaleFactor.clamp(
            DeviceType.small.scaleFactor,
            DeviceType.tablet.scaleFactor,
          ),
        ),
        maxWidth: AppDimens.maxWidth,
        minWidth: AppDimens.minWidth,
        defaultScale: true,
        breakpoints: [
          ResponsiveBreakpoint.resize(
            DeviceType.small.widthBreakPoint,
            name: DeviceType.small.name,
            scaleFactor: DeviceType.small.scaleFactor,
          ),
          ResponsiveBreakpoint.resize(
            DeviceType.regular.widthBreakPoint,
            name: DeviceType.regular.name,
            scaleFactor: DeviceType.regular.scaleFactor,
          ),
          ResponsiveBreakpoint.autoScale(
            DeviceType.tablet.widthBreakPoint,
            name: DeviceType.tablet.name,
            scaleFactor: DeviceType.tablet.scaleFactor,
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final initialThemeMode = themeMode ?? AdaptiveThemeMode.system;

    return Provider.value(
      value: getIt,
      child: RestartAppWidget(
        child: AppConnectivityChecker(
          child: Builder(
            builder: (context) {
              final MainRouter router = mainRouter ?? MainRouter();

              return AdaptiveTheme(
                light: InformedTheme.light,
                dark: InformedTheme.dark,
                initial: initialThemeMode,
                builder: (lightTheme, darkTheme) {
                  return MaterialApp.router(
                    debugShowCheckedModeBanner: !kIsTest,
                    theme: lightTheme,
                    darkTheme: darkTheme,
                    localizationsDelegates: PhraseLocalizations.localizationsDelegates,
                    supportedLocales: PhraseLocalizations.supportedLocales,
                    routeInformationParser: router.defaultRouteParser(),
                    routerDelegate: router.delegate(
                      navigatorObservers: () => [
                        // To solve issue with Hero animations in tab navigation - https://github.com/Milad-Akarie/auto_route_library/issues/418#issuecomment-997704836
                        HeroController(),
                        getIt<MainNavigationObserver>(),
                        if (!kIsTest) SentryNavigatorObserver(),
                      ],
                    ),
                    builder: (context, child) {
                      final mediaQuery = MediaQuery.of(context);
                      return NoScrollGlow(
                        child: responsiveBuilder(
                          mediaQuery,
                          ImagePrecachingView(
                            child: child!,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
