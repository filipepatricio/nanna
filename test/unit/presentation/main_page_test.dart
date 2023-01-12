import 'package:better_informed_mobile/data/app_link/app_link_data_source.dart';
import 'package:better_informed_mobile/domain/deep_link/deep_link_repository.dart';
import 'package:better_informed_mobile/domain/push_notification/data/registered_push_token.dart';
import 'package:better_informed_mobile/domain/push_notification/push_notification_repository.dart';
import 'package:better_informed_mobile/exports.dart' hide TopicPage;
import 'package:better_informed_mobile/presentation/page/daily_brief/daily_brief_page.dart';
import 'package:better_informed_mobile/presentation/page/media/media_item_page.dart';
import 'package:better_informed_mobile/presentation/page/settings/appearance/settings_appearance_page.dart';
import 'package:better_informed_mobile/presentation/page/settings/main/settings_main_page.dart';
import 'package:better_informed_mobile/presentation/page/settings/notifications/settings_notifications_page.dart';
import 'package:better_informed_mobile/presentation/page/subscription/subscription_page.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_page.dart';
import 'package:better_informed_mobile/presentation/widget/back_text_button.dart';
import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../finders.dart';
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

  testWidgets('topic link navigates to topic page', (tester) async {
    when(appLinkDataSource.getInitialAction()).thenAnswer((_) async => Uri.parse('http://informed/topics/slug'));

    await tester.startApp(
      dependencyOverride: (getIt) async {
        getIt.registerFactory<AppLinkDataSource>(() => appLinkDataSource);
      },
    );

    expect(find.byType(TopicPage), findsOneWidget);
    await tester.tap(find.byType(BackTextButton));
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

  testWidgets('unsubscribe link navigates to notifications settings', (tester) async {
    when(appLinkDataSource.getInitialAction()).thenAnswer((_) async => Uri.parse('http://informed/unsubscribe'));

    await tester.startApp(
      dependencyOverride: (getIt) async {
        getIt.registerFactory<AppLinkDataSource>(() => appLinkDataSource);
      },
    );

    expect(find.byType(SettingsNotificationsPage), findsOneWidget);
  });

  testWidgets('profile settings link navigates to settings', (tester) async {
    when(appLinkDataSource.getInitialAction()).thenAnswer((_) async => Uri.parse('http://informed/profile/settings'));

    await tester.startApp(
      dependencyOverride: (getIt) async {
        getIt.registerFactory<AppLinkDataSource>(() => appLinkDataSource);
      },
    );

    expect(find.byType(SettingsMainPage), findsOneWidget);
  });

  testWidgets('profile appearance link navigates to appearance settings', (tester) async {
    when(appLinkDataSource.getInitialAction())
        .thenAnswer((_) async => Uri.parse('http://informed/profile/settings/appearance'));

    await tester.startApp(
      dependencyOverride: (getIt) async {
        getIt.registerFactory<AppLinkDataSource>(() => appLinkDataSource);
      },
    );

    expect(find.byType(SettingsAppearancePage), findsOneWidget);
  });
  testWidgets('base settings link navigates to settings', (tester) async {
    when(appLinkDataSource.getInitialAction()).thenAnswer((_) async => Uri.parse('http://informed/settings'));

    await tester.startApp(
      dependencyOverride: (getIt) async {
        getIt.registerFactory<AppLinkDataSource>(() => appLinkDataSource);
      },
    );

    expect(find.byType(SettingsMainPage), findsOneWidget);
  });

  testWidgets('article link navigates to article page', (tester) async {
    when(appLinkDataSource.getInitialAction()).thenAnswer((_) async => Uri.parse('http://informed/articles/slug'));

    await tester.startApp(
      dependencyOverride: (getIt) async {
        getIt.registerFactory<AppLinkDataSource>(() => appLinkDataSource);
      },
    );

    expect(find.byType(MediaItemPage), findsOneWidget);
    await tester.tap(find.byType(BackTextButton));
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
    await tester.tap(find.byType(BackTextButton));
    await tester.pumpAndSettle();
    expect(find.byType(TopicPage), findsOneWidget);
    await tester.tap(find.byType(BackTextButton));
    await tester.pumpAndSettle();
    expect(find.byType(DailyBriefPage), findsOneWidget);
  });

  testWidgets('subscribe link navigates to subscription page', (tester) async {
    when(appLinkDataSource.getInitialAction()).thenAnswer((_) async => Uri.parse('http://informed/subscribe'));

    await tester.startApp(
      dependencyOverride: (getIt) async {
        getIt.registerFactory<AppLinkDataSource>(() => appLinkDataSource);
      },
    );

    expect(find.byType(SubscriptionPage), findsOneWidget);
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
      await tester.tap(find.byType(BackTextButton));
      await tester.pumpAndSettle();
      expect(find.byType(DailyBriefPage), findsOneWidget);
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
      await tester.tap(find.byType(BackTextButton));
      await tester.pumpAndSettle();
      expect(find.byType(DailyBriefPage), findsOneWidget);
    });

    testWidgets('article topic', (tester) async {
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
      await tester.tap(find.byType(BackTextButton));
      await tester.pumpAndSettle();
      expect(find.byType(DailyBriefPage), findsOneWidget);
    });
  });
}
