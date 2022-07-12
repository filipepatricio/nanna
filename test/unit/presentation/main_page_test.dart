import 'package:better_informed_mobile/data/app_link/app_link_data_source.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/daily_brief_page.dart';
import 'package:better_informed_mobile/presentation/page/media/media_item_page.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../generated_mocks.mocks.dart';
import '../unit_test_utils.dart';

void main() {
  late MockAppLinkDataSource appLinkDataSource;

  setUp(() {
    appLinkDataSource = MockAppLinkDataSource();
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
    when(appLinkDataSource.getInitialAction())
        .thenAnswer((_) async => Uri.parse('http://informed/topics/slug/articles/slug'));

    await tester.startApp(
      dependencyOverride: (getIt) async {
        getIt.registerFactory<AppLinkDataSource>(() => appLinkDataSource);
      },
    );

    expect(find.byType(MediaItemPage), findsOneWidget);
    await tester.tap(find.byIcon(Icons.arrow_back_ios_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(TopicPage), findsOneWidget);
    await tester.tap(find.byIcon(Icons.arrow_back_ios_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(DailyBriefPage), findsOneWidget);
  });
}
