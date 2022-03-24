import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/better_informed_app.dart';
import 'package:better_informed_mobile/presentation/routing/main_router.dart';
import 'package:flutter_test/flutter_test.dart';

import 'flutter_test_config.dart';

extension WidgetTesterExtension on WidgetTester {
  Future<void> startApp({
    String? initialDeepLink,
    PageRouteInfo initialRoute = defaultInitialRoute,
  }) async {
    final isTab = isTabRoute(initialRoute);

    final mainRouter = MainRouter(mainRouterKey);

    await pumpWidget(BetterInformedApp(mainRouter: mainRouter));

    await pumpAndSettle();

    if (initialRoute != defaultInitialRoute) {
      if (isTab) {
        await mainRouter.navigate(TabBarPageRoute(children: [initialRoute]));
      } else {
        await mainRouter.navigate(initialRoute);
      }
      await pumpAndSettle();
    }
  }
}
