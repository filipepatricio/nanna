import 'package:better_informed_mobile/domain/feature_flags/use_case/should_use_text_size_selector_use_case.di.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/widget/article/article_text_scale_factor_selector.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../generated_mocks.mocks.dart';
import '../../unit_test_utils.dart';

void main() {
  testWidgets(
    'text size selector is shown if flag is true',
    (tester) async {
      final useCase = MockShouldUseTextSizeSelectorUseCase();
      when(useCase()).thenAnswer((_) async => true);

      await tester.startApp(
        dependencyOverride: (getIt) async {
          getIt.registerFactory<ShouldUseTextSizeSelectorUseCase>(() => useCase);
        },
        initialRoute: const MainPageRoute(
          children: [
            SettingsAppearancePageRoute(),
          ],
        ),
      );

      expect(find.byType(ArticleTextScaleFactorSelector), findsOneWidget);
    },
  );

  testWidgets(
    'text size selector is not shown if flag is false',
    (tester) async {
      final useCase = MockShouldUseTextSizeSelectorUseCase();
      when(useCase()).thenAnswer((_) async => false);

      await tester.startApp(
        dependencyOverride: (getIt) async {
          getIt.registerFactory<ShouldUseTextSizeSelectorUseCase>(() => useCase);
        },
        initialRoute: const MainPageRoute(
          children: [
            SettingsAppearancePageRoute(),
          ],
        ),
      );

      expect(find.byType(ArticleTextScaleFactorSelector), findsNothing);
    },
  );
}
