import 'package:better_informed_mobile/domain/util/use_case/should_update_app_use_case.di.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../finders.dart';
import '../../../flutter_test_config.dart';
import '../../../generated_mocks.mocks.dart';
import '../../unit_test_utils.dart';

void main() {
  testWidgets(
    'dialog shows up when app is outdated',
    (tester) async {
      final useCase = MockShouldUpdateAppUseCase();
      when(useCase.call()).thenAnswer((_) async => true);

      await tester.startApp(
        dependencyOverride: (getIt) async {
          getIt.registerFactory<ShouldUpdateAppUseCase>(() => useCase);
        },
      );
      expect(find.byText(l10n.update_title), findsOneWidget);
    },
  );
}
