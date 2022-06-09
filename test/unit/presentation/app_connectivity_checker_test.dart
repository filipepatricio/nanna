import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/widget/app_connectivity_checker/app_connectivity_checker_cubit.di.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes.dart';
import '../../finders.dart';
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
      expect(find.byText(LocaleKeys.noConnection_title.tr()), findsOneWidget);
    },
  );
}
