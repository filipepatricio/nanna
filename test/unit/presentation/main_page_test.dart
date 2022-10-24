import 'package:better_informed_mobile/data/app_link/app_link_data_source.dart';
import 'package:better_informed_mobile/domain/deep_link/deep_link_repository.dart';
import 'package:better_informed_mobile/exports.dart' hide TopicPage;
import 'package:better_informed_mobile/presentation/page/daily_brief/daily_brief_page.dart';
import 'package:better_informed_mobile/presentation/page/media/media_item_page.dart';
import 'package:better_informed_mobile/presentation/page/subscription/subscription_page.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../finders.dart';
import '../../generated_mocks.mocks.dart';
import '../../test_data.dart';
import '../unit_test_utils.dart';

void main() {
  late MockAppLinkDataSource appLinkDataSource;
  late MockDeepLinkRepository deepLinkRepository;

  setUp(() {
    appLinkDataSource = MockAppLinkDataSource();
    deepLinkRepository = MockDeepLinkRepository();
    when(appLinkDataSource.listenForIncomingActions()).thenAnswer((_) => const Stream.empty());
  });

  testWidgets('topic link navigates to topic page', (tester) async {
    when(appLinkDataSource.getInitialAction()).thenAnswer((_) async => Uri.parse('http://informed/topics/slug'));

    await tester.startApp(
      dependencyOverride: (getIt) async {
        getIt.registerFactory<AppLinkDataSource>(() => appLinkDataSource);
      },
    );

    expect(find.byType(TopicPage), findsOneWidget);
    await tester.tap(find.byIcon(Icons.arrow_back_ios_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(DailyBriefPage), findsOneWidget);
  });

  testWidgets('magic link does not navigate when session is active', (tester) async {
    when(appLinkDataSource.getInitialAction()).thenAnswer((_) async => Uri.parse('http://informed/magic'));

    await tester.startApp(
      dependencyOverride: (getIt) async {
        getIt.registerFactory<AppLinkDataSource>(() => appLinkDataSource);
      },
    );

    expect(find.byType(DailyBriefPage), findsOneWidget);
  });

  testWidgets('article link navigates to article page', (tester) async {
    when(appLinkDataSource.getInitialAction()).thenAnswer((_) async => Uri.parse('http://informed/articles/slug'));

    await tester.startApp(
      dependencyOverride: (getIt) async {
        getIt.registerFactory<AppLinkDataSource>(() => appLinkDataSource);
      },
    );

    expect(find.byType(MediaItemPage), findsOneWidget);
    await tester.tap(find.byIcon(Icons.arrow_back_ios_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(DailyBriefPage), findsOneWidget);
  });

  testWidgets('combined link navigates to topic and article pages', (tester) async {
    final topic = TestData.topicWithEditorOwner;

    when(appLinkDataSource.getInitialAction()).thenAnswer(
      (_) async => Uri.parse(
        'http://informed/topics/${topic.slug}/articles/${TestData.premiumArticleWithAudio.slug}',
      ),
    );

    await tester.startApp(
      dependencyOverride: (getIt) async {
        getIt.registerFactory<AppLinkDataSource>(() => appLinkDataSource);
      },
    );

    expect(find.byType(MediaItemPage), findsOneWidget);
    await tester.fling(find.byType(MediaItemPage), const Offset(0, -20000), 100);
    await tester.pumpAndSettle();
    expect(
      find.byText(
        LocaleKeys.article_moreFromTopic.tr(args: [topic.strippedTitle]),
        skipOffstage: false,
      ),
      findsOneWidget,
    );
    await tester.tap(find.byIcon(Icons.arrow_back_ios_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(TopicPage), findsOneWidget);
    await tester.tap(find.byIcon(Icons.arrow_back_ios_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(DailyBriefPage), findsOneWidget);
  });

  testWidgets('subscribe deep link navigates to subscription page', (tester) async {
    when(deepLinkRepository.subscribeForDeepLink()).thenAnswer((_) => Stream.value('/subscribe'));

    await tester.startApp(
      dependencyOverride: (getIt) async {
        getIt.registerFactory<DeepLinkRepository>(() => deepLinkRepository);
      },
    );

    expect(find.byType(SubscriptionPage), findsOneWidget);
  });
}
