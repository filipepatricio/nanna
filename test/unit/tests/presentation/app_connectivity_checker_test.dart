import 'package:better_informed_mobile/domain/networking/use_case/is_internet_connection_available_use_case.di.dart';
import 'package:better_informed_mobile/presentation/widget/no_connection_banner/no_connection_banner.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../generated_mocks.mocks.dart';
import '../../unit_test_utils.dart';

void main() {
  testWidgets(
    'dialog shows up when app is offline',
    (tester) async {
      final useCase = MockIsInternetConnectionAvailableUseCase();

      when(useCase.call()).thenAnswer((_) async => false);
      when(useCase.stream).thenAnswer((_) => Stream.value(false));

      await tester.startApp(
        dependencyOverride: (getIt) async {
          getIt.registerFactory<IsInternetConnectionAvailableUseCase>(() => useCase);
        },
      );
      expect(find.byType(NoConnectionBanner), findsOneWidget);
    },
  );
}
