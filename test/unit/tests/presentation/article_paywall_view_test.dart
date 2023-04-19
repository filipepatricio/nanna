import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:better_informed_mobile/domain/subscription/data/active_subscription.dt.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_active_subscription_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/purchase_subscription_use_case.di.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/widget/subscription/subscribe_button.dart';
import 'package:better_informed_mobile/presentation/widget/subscription/subscription_plan_cell.dart';
import 'package:better_informed_mobile/presentation/widget/subscription/trial_timeline.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../fakes.dart';
import '../../../finders.dart';
import '../../../flutter_test_config.dart';
import '../../../generated_mocks.mocks.dart';
import '../../../test_data.dart';
import '../../unit_test_utils.dart';

void main() {
  late FakeGetActiveSubscriptionUseCase activeSubscriptionUseCase;
  late MockGetArticleUseCase getArticleUseCase;
  late MockPurchaseSubscriptionUseCase purchaseSubscriptionUseCase;

  setUp(() {
    purchaseSubscriptionUseCase = MockPurchaseSubscriptionUseCase();
    activeSubscriptionUseCase = FakeGetActiveSubscriptionUseCase(activeSubscription: ActiveSubscription.free());
    getArticleUseCase = MockGetArticleUseCase();

    when(getArticleUseCase.single(any)).thenAnswer(
      (_) async => Article(
        metadata: TestData.premiumArticleWithAudioAndLocked,
        content: TestData.lockedArticle.content,
      ),
    );
  });

  testWidgets('pressing subscription button invokes purchase', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    final plan = TestData.subscriptionPlansWithTrial.first;

    when(purchaseSubscriptionUseCase.call(plan)).thenAnswer((realInvocation) async => true);

    await tester.startApp(
      dependencyOverride: (getIt) async {
        getIt.registerFactory<PurchaseSubscriptionUseCase>(() => purchaseSubscriptionUseCase);
        getIt.registerFactory<GetActiveSubscriptionUseCase>(() => activeSubscriptionUseCase);
      },
      initialRoute: MainPageRoute(
        children: [
          MediaItemPageRoute(slug: TestData.premiumArticleWithAudioAndLocked.slug),
        ],
      ),
    );

    expect(find.byType(SubscriptionPlanCell), findsNWidgets(2));
    expect(find.byType(TrialTimeline), findsOneWidget);
    expect(find.byText(l10n.subscription_restorePurchase), findsOneWidget);
    expect(find.byText(l10n.subscription_redeemCode), findsOneWidget);

    final subscribeButton = find.byType(SubscribeButton);
    await tester.dragUntilVisible(subscribeButton, find.byType(Scrollable), const Offset(0, 200));
    await tester.pumpAndSettle();
    await tester.tap(subscribeButton);

    verify(purchaseSubscriptionUseCase.call(plan));

    debugDefaultTargetPlatformOverride = null;
  });
}
