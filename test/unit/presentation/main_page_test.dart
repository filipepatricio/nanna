import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/data/app_link/app_link_data_source.dart';
import 'package:better_informed_mobile/domain/deep_link/deep_link_repository.dart';
import 'package:better_informed_mobile/domain/push_notification/data/registered_push_token.dart';
import 'package:better_informed_mobile/domain/push_notification/push_notification_repository.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/daily_brief_page.dart';
import 'package:better_informed_mobile/presentation/page/media/media_item_page.dart';
import 'package:better_informed_mobile/presentation/page/settings/appearance/settings_appearance_page.dart';
import 'package:better_informed_mobile/presentation/page/settings/main/settings_main_page.dart';
import 'package:better_informed_mobile/presentation/page/settings/manage_my_interests/settings_manage_my_interests_page.dart';
import 'package:better_informed_mobile/presentation/page/settings/notifications/settings_notifications_page.dart';
import 'package:better_informed_mobile/presentation/page/subscription/subscription_page.dart';
import 'package:better_informed_mobile/presentation/page/tab_bar/tab_bar_page.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_page.dart';
import 'package:better_informed_mobile/presentation/widget/back_text_button.dart';
import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../finders.dart';
import '../../flutter_test_config.dart';
import '../../generated_mocks.mocks.dart';
import '../../test_data.dart';
import '../unit_test_utils.dart';

void main() {
  late MockPushNotificationRepository pushNotificationRepository;
  late MockAppLinkDataSource appLinkDataSource;
  late MockDeepLinkRepository deepLinkRepository;

  setUp(() {
    appLinkDataSource = MockAppLinkDataSource();
    deepLinkRepository = MockDeepLinkRepository();
    pushNotificationRepository = MockPushNotificationRepository();

    when(appLinkDataSource.listenForIncomingActions()).thenAnswer((_) => const Stream.empty());
    when(pushNotificationRepository.registerToken()).thenAnswer(
      (_) async => RegisteredPushToken(token: '000-000', updatedAt: clock.now()),
    );
  });

  group('handles applinks', () {
    testWidgets('topic', (tester) async {
      when(appLinkDataSource.getInitialAction()).thenAnswer((_) async => Uri.parse('http://informed/topics/slug'));

      await tester.startApp(
        dependencyOverride: (getIt) async {
          getIt.registerFactory<AppLinkDataSource>(() => appLinkDataSource);
        },
      );

      expect(find.byType(TopicPage), findsOneWidget);
      expectDailyBriefTabSelected();
    });

    testWidgets('magic link', (tester) async {
      when(appLinkDataSource.getInitialAction()).thenAnswer((_) async => Uri.parse('http://informed/magic'));

      await tester.startApp(
        dependencyOverride: (getIt) async {
          getIt.registerFactory<AppLinkDataSource>(() => appLinkDataSource);
        },
      );

      expect(find.byType(DailyBriefPage), findsOneWidget);
    });

    testWidgets('unsubscribe', (tester) async {
      when(appLinkDataSource.getInitialAction()).thenAnswer((_) async => Uri.parse('http://informed/unsubscribe'));

      await tester.startApp(
        dependencyOverride: (getIt) async {
          getIt.registerFactory<AppLinkDataSource>(() => appLinkDataSource);
        },
      );

      expect(find.byType(SettingsNotificationsPage), findsOneWidget);
      expectProfileTabSelected();
    });

    testWidgets('settings', (tester) async {
      when(appLinkDataSource.getInitialAction()).thenAnswer((_) async => Uri.parse('http://informed/settings'));

      await tester.startApp(
        dependencyOverride: (getIt) async {
          getIt.registerFactory<AppLinkDataSource>(() => appLinkDataSource);
        },
      );

      expect(find.byType(SettingsMainPage), findsOneWidget);
      expectDailyBriefTabSelected();
    });

    testWidgets('settings interests', (tester) async {
      when(appLinkDataSource.getInitialAction())
          .thenAnswer((_) async => Uri.parse('http://informed/settings/interests'));

      await tester.startApp(
        dependencyOverride: (getIt) async {
          getIt.registerFactory<AppLinkDataSource>(() => appLinkDataSource);
        },
      );

      expect(find.byType(SettingsManageMyInterestsPage), findsOneWidget);
      await tester.tap(find.byType(BackTextButton));
      await tester.pumpAndSettle();
      expect(find.byType(SettingsMainPage), findsOneWidget);
      expectDailyBriefTabSelected();
    });

    testWidgets('article', (tester) async {
      when(appLinkDataSource.getInitialAction()).thenAnswer((_) async => Uri.parse('http://informed/articles/slug'));

      await tester.startApp(
        dependencyOverride: (getIt) async {
          getIt.registerFactory<AppLinkDataSource>(() => appLinkDataSource);
        },
      );

      expect(find.byType(MediaItemPage), findsOneWidget);
      expectDailyBriefTabSelected();
    });

    testWidgets('topic article', (tester) async {
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
          l10n.article_moreFromTopic(topic.strippedTitle),
          skipOffstage: false,
        ),
        findsOneWidget,
      );
      await tester.tap(find.byType(BackTextButton));
      await tester.pumpAndSettle();
      expect(find.byType(TopicPage), findsOneWidget);
      expectDailyBriefTabSelected();
    });

    testWidgets('subscribe', (tester) async {
      when(appLinkDataSource.getInitialAction()).thenAnswer((_) async => Uri.parse('http://informed/subscribe'));

      await tester.startApp(
        dependencyOverride: (getIt) async {
          getIt.registerFactory<AppLinkDataSource>(() => appLinkDataSource);
        },
      );

      expect(find.byType(SubscriptionPage), findsOneWidget);
      expectDailyBriefTabSelected();
    });
  });

  group('handles applinks to profile tab', () {
    testWidgets('settings', (tester) async {
      when(appLinkDataSource.getInitialAction()).thenAnswer((_) async => Uri.parse('http://informed/profile/settings'));

      await tester.startApp(
        dependencyOverride: (getIt) async {
          getIt.registerFactory<AppLinkDataSource>(() => appLinkDataSource);
        },
      );

      expect(find.byType(SettingsMainPage), findsOneWidget);
      expectProfileTabSelected();
    });

    testWidgets('settings appearance', (tester) async {
      when(appLinkDataSource.getInitialAction())
          .thenAnswer((_) async => Uri.parse('http://informed/profile/settings/appearance'));

      await tester.startApp(
        dependencyOverride: (getIt) async {
          getIt.registerFactory<AppLinkDataSource>(() => appLinkDataSource);
        },
      );

      expect(find.byType(SettingsAppearancePage), findsOneWidget);
      await tester.tap(find.byType(BackTextButton));
      await tester.pumpAndSettle();
      expect(find.byType(SettingsMainPage), findsOneWidget);
      expectProfileTabSelected();
    });

    testWidgets('settings interests', (tester) async {
      when(appLinkDataSource.getInitialAction())
          .thenAnswer((_) async => Uri.parse('http://informed/profile/settings/interests'));

      await tester.startApp(
        dependencyOverride: (getIt) async {
          getIt.registerFactory<AppLinkDataSource>(() => appLinkDataSource);
        },
      );

      expect(find.byType(SettingsManageMyInterestsPage), findsOneWidget);
      await tester.tap(find.byType(BackTextButton));
      await tester.pumpAndSettle();
      expect(find.byType(SettingsMainPage), findsOneWidget);
      expectProfileTabSelected();
    });
  });

  group('handles appsflyer deeplink', () {
    testWidgets('subscribe', (tester) async {
      when(deepLinkRepository.subscribeForDeepLink()).thenAnswer((_) => Stream.value('/subscribe'));

      await tester.startApp(
        dependencyOverride: (getIt) async {
          getIt.registerFactory<DeepLinkRepository>(() => deepLinkRepository);
        },
      );

      expect(find.byType(SubscriptionPage), findsOneWidget);
      expectDailyBriefTabSelected();
    });
  });

  group('handles incoming push navigation', () {
    testWidgets('article', (tester) async {
      when(pushNotificationRepository.pushNotificationOpenStream()).thenAnswer(
        (_) => Stream.value(TestData.articlePushNotification),
      );

      await tester.startApp(
        dependencyOverride: (getIt) async {
          getIt.registerFactory<PushNotificationRepository>(() => pushNotificationRepository);
        },
      );

      expect(find.byType(MediaItemPage), findsOneWidget);
      expectDailyBriefTabSelected();
    });

    testWidgets('topic', (tester) async {
      when(pushNotificationRepository.pushNotificationOpenStream()).thenAnswer(
        (_) => Stream.value(TestData.topicPushNotification),
      );

      await tester.startApp(
        dependencyOverride: (getIt) async {
          getIt.registerFactory<PushNotificationRepository>(() => pushNotificationRepository);
        },
      );

      expect(find.byType(TopicPage), findsOneWidget);
      expectDailyBriefTabSelected();
    });

    testWidgets('topic article', (tester) async {
      when(pushNotificationRepository.pushNotificationOpenStream()).thenAnswer(
        (_) => Stream.value(TestData.articleTopicPushNotification),
      );

      await tester.startApp(
        dependencyOverride: (getIt) async {
          getIt.registerFactory<PushNotificationRepository>(() => pushNotificationRepository);
        },
      );

      expect(find.byType(MediaItemPage), findsOneWidget);
      await tester.tap(find.byType(BackTextButton));
      await tester.pumpAndSettle();
      expect(find.byType(TopicPage), findsOneWidget);
      expectDailyBriefTabSelected();
    });

    testWidgets('settings notifications', (tester) async {
      when(pushNotificationRepository.hasPermission()).thenAnswer((_) async => true);
      when(pushNotificationRepository.pushNotificationOpenStream()).thenAnswer(
        (_) => Stream.value(TestData.settingsNotificationsPushNotification),
      );

      await tester.startApp(
        dependencyOverride: (getIt) async {
          getIt.registerFactory<PushNotificationRepository>(() => pushNotificationRepository);
        },
      );

      expect(find.byType(SettingsNotificationsPage), findsOneWidget);
      await tester.tap(find.byType(BackTextButton));
      await tester.pumpAndSettle();
      expect(find.byType(SettingsMainPage), findsOneWidget);
      expectProfileTabSelected();
    });

    testWidgets('settings interests', (tester) async {
      when(pushNotificationRepository.pushNotificationOpenStream()).thenAnswer(
        (_) => Stream.value(TestData.settingsInterestsPushNotification),
      );

      await tester.startApp(
        dependencyOverride: (getIt) async {
          getIt.registerFactory<PushNotificationRepository>(() => pushNotificationRepository);
        },
      );

      expect(find.byType(SettingsManageMyInterestsPage), findsOneWidget);
      await tester.tap(find.byType(BackTextButton));
      await tester.pumpAndSettle();
      expect(find.byType(SettingsMainPage), findsOneWidget);
      expectProfileTabSelected();
    });

    testWidgets('settings appearance', (tester) async {
      when(pushNotificationRepository.pushNotificationOpenStream()).thenAnswer(
        (_) => Stream.value(TestData.settingsAppearancePushNotification),
      );

      await tester.startApp(
        dependencyOverride: (getIt) async {
          getIt.registerFactory<PushNotificationRepository>(() => pushNotificationRepository);
        },
      );

      expect(find.byType(SettingsAppearancePage), findsOneWidget);
      await tester.tap(find.byType(BackTextButton));
      await tester.pumpAndSettle();
      expect(find.byType(SettingsMainPage), findsOneWidget);
      expectProfileTabSelected();
    });
  });
}

void expectDailyBriefTabSelected() {
  expect(tabBarScaffoldKey.currentContext?.tabsRouter.activeIndex, 0);
}

void expectProfileTabSelected() {
  expect(tabBarScaffoldKey.currentContext?.tabsRouter.activeIndex, 2);
}
