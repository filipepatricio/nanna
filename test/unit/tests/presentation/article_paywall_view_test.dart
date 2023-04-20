void main() {
  // testWidgets('pressing trial subscription button invokes purchase', (tester) async {
  //   final article = Article(
  //     metadata: TestData.premiumArticleWithAudioAndLocked,
  //     content: TestData.fullArticle.content,
  //   );
  //   final plan = TestData.subscriptionPlansWithTrial.first;
  //
  //   final purchaseSubscriptionUseCase = MockPurchaseSubscriptionUseCase();
  //   final getArticlePaywallPreferredPlanUseCase = FakeGetArticlePaywallPreferredPlanUseCase(
  //     ArticlePaywallSubscriptionPlanPack.singleTrial(plan),
  //   );
  //
  //   when(purchaseSubscriptionUseCase.call(plan)).thenAnswer((realInvocation) async => true);
  //
  //   await tester.startApp(
  //     dependencyOverride: (getIt) async {
  //       getIt.registerFactory<PurchaseSubscriptionUseCase>(() => purchaseSubscriptionUseCase);
  //       getIt.registerFactory<GetArticlePaywallPreferredPlanUseCase>(() => getArticlePaywallPreferredPlanUseCase);
  //     },
  //     initialRoute: PlaceholderPageRoute(
  //       child: SnackbarParentView(
  //         child: Scaffold(
  //           body: SingleChildScrollView(
  //             child: ArticlePaywallView(
  //               article: article,
  //               child: Text(article.content.content),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  //
  //   final subscribeButton = find.byType(SubscribeButton);
  //
  //   await tester.dragUntilVisible(subscribeButton, find.byType(Scrollable), const Offset(0, 200));
  //   await tester.tap(subscribeButton);
  //
  //   verify(purchaseSubscriptionUseCase.call(plan));
  // });
  //
  // testWidgets('pressing standard subscription button invokes purchase for seelcted plan', (tester) async {
  //   final article = Article(
  //     metadata: TestData.premiumArticleWithAudioAndLocked,
  //     content: TestData.fullArticle.content,
  //   );
  //   final plans = TestData.subscriptionPlansWithoutTrial;
  //
  //   final purchaseSubscriptionUseCase = MockPurchaseSubscriptionUseCase();
  //   final getArticlePaywallPreferredPlanUseCase = FakeGetArticlePaywallPreferredPlanUseCase(
  //     ArticlePaywallSubscriptionPlanPack.multiple(SubscriptionPlanGroup(plans: plans)),
  //   );
  //
  //   when(purchaseSubscriptionUseCase.call(plans.last)).thenAnswer((realInvocation) async => true);
  //
  //   await tester.startApp(
  //     dependencyOverride: (getIt) async {
  //       getIt.registerFactory<PurchaseSubscriptionUseCase>(() => purchaseSubscriptionUseCase);
  //       getIt.registerFactory<GetArticlePaywallPreferredPlanUseCase>(() => getArticlePaywallPreferredPlanUseCase);
  //     },
  //     initialRoute: PlaceholderPageRoute(
  //       child: SnackbarParentView(
  //         child: Scaffold(
  //           body: SingleChildScrollView(
  //             child: ArticlePaywallView(
  //               article: article,
  //               child: Text(article.content.content),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  //
  //   final subscribeButton = find.byType(SubscribeButton);
  //   await tester.dragUntilVisible(subscribeButton, find.byType(Scrollable), const Offset(0, 200));
  //
  //   await tester.tap(find.byType(SubscriptionPlanCell).last);
  //   await tester.pumpAndSettle();
  //   await tester.tap(subscribeButton);
  //
  //   verify(purchaseSubscriptionUseCase.call(plans.last));
  // });
}
