import 'package:better_informed_mobile/domain/networking/use_case/is_internet_connection_available_use_case.di.dart';
import 'package:better_informed_mobile/presentation/widget/app_connectivity_checker/app_connectivity_checker.dart';
import 'package:mockito/mockito.dart';

import '../../generated_mocks.mocks.dart';
import '../visual_test_utils.dart';

void main() {
  visualTest(AppConnectivityChecker, (tester) async {
    final useCase = MockIsInternetConnectionAvailableUseCase();

    when(useCase.call()).thenAnswer((_) async => false);
    when(useCase.stream).thenAnswer((_) => Stream.value(false));

    await tester.startApp(
      dependencyOverride: (getIt) async {
        getIt.registerFactory<IsInternetConnectionAvailableUseCase>(() => useCase);
      },
    );
    await tester.matchGoldenFile();
  });
}
