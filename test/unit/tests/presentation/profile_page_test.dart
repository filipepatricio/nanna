import 'package:better_informed_mobile/domain/subscription/data/active_subscription.dt.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_active_subscription_use_case.di.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/saved/bookmark_list_view/bookmark_list_view.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../generated_mocks.mocks.dart';
import '../../../test_data.dart';
import '../../unit_test_utils.dart';

void main() {
  testWidgets(
    'banner is shown for free users',
    (tester) async {
      final getActiveSubscriptionUseCase = MockGetActiveSubscriptionUseCase();
      when(getActiveSubscriptionUseCase.call()).thenAnswer((_) async => ActiveSubscription.free());
      when(getActiveSubscriptionUseCase.stream).thenAnswer((_) => Stream.value(ActiveSubscription.free()));

      await tester.startApp(
        initialRoute: const ProfileTabGroupRouter(),
        dependencyOverride: (getIt) async {
          getIt.registerFactory<GetActiveSubscriptionUseCase>(() => getActiveSubscriptionUseCase);
        },
      );

      expect(find.byType(FreeUserBanner), findsOneWidget);
    },
  );

  testWidgets(
    'banner is not shown for premium users',
    (tester) async {
      final getActiveSubscriptionUseCase = MockGetActiveSubscriptionUseCase();
      when(getActiveSubscriptionUseCase.call()).thenAnswer((_) async => TestData.activeSubscription);
      when(getActiveSubscriptionUseCase.stream).thenAnswer((_) => Stream.value(TestData.activeSubscription));

      await tester.startApp(
        initialRoute: const ProfileTabGroupRouter(),
        dependencyOverride: (getIt) async {
          getIt.registerFactory<GetActiveSubscriptionUseCase>(() => getActiveSubscriptionUseCase);
        },
      );

      expect(find.byType(FreeUserBanner), findsNothing);
    },
  );
}
