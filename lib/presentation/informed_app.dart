import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/restart_app_widget.dart';
import 'package:better_informed_mobile/presentation/routing/observers/main_navigation_observer.di.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/app_theme.dart';
import 'package:better_informed_mobile/presentation/util/device_type.dart';
import 'package:better_informed_mobile/presentation/util/scroll_controller_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class InformedApp extends HookWidget {
  const InformedApp({
    required this.getIt,
    this.mainRouter,
    //TODO: Change to [ThemeMode.system] when dark mode work is ready
    this.themeMode = ThemeMode.light,
    Key? key,
  }) : super(key: key);

  final GetIt getIt;
  final MainRouter? mainRouter;
  final ThemeMode themeMode;

  Widget responsiveBuilder(Widget? child) => ResponsiveWrapper.builder(
        child,
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
    if (kIsTest) {
      return Provider.value(
        value: getIt,
        child: RestartAppWidget(
          child: Builder(
            builder: (context) {
              final MainRouter router = mainRouter ?? MainRouter();

              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                routeInformationParser: router.defaultRouteParser(),
                routerDelegate: router.delegate(),
                theme: InformedTheme.light,
                darkTheme: InformedTheme.dark,
                themeMode: themeMode,
                builder: (context, child) {
                  return NoScrollGlow(
                    child: responsiveBuilder(child),
                  );
                },
              );
            },
          ),
        ),
      );
    }

    return Provider.value(
      value: getIt,
      child: RestartAppWidget(
        child: Builder(
          builder: (context) {
            final MainRouter router = mainRouter ?? MainRouter();

            return MaterialApp.router(
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              routeInformationParser: router.defaultRouteParser(),
              routerDelegate: router.delegate(
                navigatorObservers: () => [
                  // To solve issue with Hero animations in tab navigation - https://github.com/Milad-Akarie/auto_route_library/issues/418#issuecomment-997704836
                  HeroController(),
                  getIt<MainNavigationObserver>(),
                  SentryNavigatorObserver(),
                ],
              ),
              theme: InformedTheme.light,
              darkTheme: InformedTheme.dark,
              themeMode: themeMode,
              builder: (context, child) {
                return NoScrollGlow(
                  child: responsiveBuilder(child),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
