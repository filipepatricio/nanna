import 'package:better_informed_mobile/presentation/widget/app_connectivity_checker/app_connectivity_checker_cubit.di.dart';
import 'package:better_informed_mobile/presentation/widget/no_connection_banner/no_connection_banner.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes.dart';
import '../unit_test_utils.dart';

void main() {
  testWidgets(
    'dialog shows up when app is offline',
    (tester) async {
      final AppConnectivityCheckerCubit cubit = FakeAppConnectivityCheckerCubit();

      await tester.startApp(
        dependencyOverride: (getIt) async {
          getIt.registerFactory<AppConnectivityCheckerCubit>(() => cubit);
        },
      );
      expect(find.byType(NoConnectionBanner), findsOneWidget);
    },
  );
}
