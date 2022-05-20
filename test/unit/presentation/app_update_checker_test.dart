import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/widget/update_app_enforcer/app_update_checker_cubit.di.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes.dart';
import '../../finders.dart';
import '../unit_test_utils.dart';

void main() {
  testWidgets(
    'dialog shows up when app is outdated',
    (tester) async {
      final AppUpdateCheckerCubit cubit = FakeAppUpdateCheckerCubit();

      await tester.startApp(
        dependencyOverride: (getIt) async {
          getIt.registerFactory<AppUpdateCheckerCubit>(() => cubit);
        },
      );
      expect(find.byText(LocaleKeys.update_title.tr()), findsOneWidget);
    },
  );
}
