import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/core/di/di_config.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/informed_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import '../flutter_test_config.dart';

typedef DependencyOverrideCallback = Future<void> Function(GetIt getIt);

const informedPlatformsVariant = TargetPlatformVariant({
  TargetPlatform.android,
  TargetPlatform.iOS,
});

extension WidgetTesterExtension on WidgetTester {
  Future<MainRouter> startApp({
    PageRouteInfo initialRoute = defaultInitialRoute,
    DependencyOverrideCallback? dependencyOverride,
  }) async {
    final isTab = isTabRoute(initialRoute);
    final mainRouter = MainRouter(GlobalKey());

    final getIt = await configureDependencies(AppConfig.mock.name);
    getIt.allowReassignment = true;
    await dependencyOverride?.call(getIt);

    await pumpWidget(
      InformedApp(
        mainRouter: mainRouter,
        getIt: getIt,
      ),
    );

    await pumpAndSettle();

    if (initialRoute != defaultInitialRoute) {
      if (isTab) {
        await mainRouter.navigate(TabBarPageRoute(children: [initialRoute]));
      } else {
        await mainRouter.navigate(initialRoute);
      }
      await pumpAndSettle();
    }

    return mainRouter;
  }
}
