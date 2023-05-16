import 'package:better_informed_mobile/domain/user/use_case/is_guest_mode_use_case.di.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/explore/categories/category_page.dart';
import 'package:mockito/mockito.dart';

import '../../flutter_test_config.dart';
import '../../generated_mocks.mocks.dart';
import '../../test_data.dart';
import '../visual_test_utils.dart';

void main() {
  visualTest(CategoryPage, (tester) async {
    await tester.startApp(
      initialRoute: ExploreTabGroupRouter(
        children: [
          CategoryPageRoute(
            category: TestData.categoryWithItems,
            openedFrom: l10n.main_exploreTab,
          ),
        ],
      ),
    );
    await tester.matchGoldenFile();
  });

  visualTest('${CategoryPage}_(guest)', (tester) async {
    final isGuestModeUseCase = MockIsGuestModeUseCase();
    when(isGuestModeUseCase.call()).thenAnswer((_) async => true);

    await tester.startApp(
      initialRoute: ExploreTabGroupRouter(
        children: [
          CategoryPageRoute(
            category: TestData.categoryWithItems,
            openedFrom: l10n.main_exploreTab,
          ),
        ],
      ),
      dependencyOverride: (getIt) async {
        getIt.registerFactory<IsGuestModeUseCase>(() => isGuestModeUseCase);
      },
    );

    await tester.matchGoldenFile();
  });
}
