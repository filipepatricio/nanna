import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/daily_brief_page.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/topic/topic_page.dart';
import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/presentation/page/entry/entry_page.dart';
import 'package:better_informed_mobile/presentation/page/explore_tab/explore_page.dart';
import 'package:better_informed_mobile/presentation/page/main/main_page.dart';
import 'package:better_informed_mobile/presentation/page/my_reads_tab/my_reads_page.dart';
import 'package:better_informed_mobile/presentation/page/onboarding/onboarding_page.dart';
import 'package:better_informed_mobile/presentation/routing/custom_route/fade_page_route.dart';
import 'package:better_informed_mobile/presentation/page/today_tab/today_page.dart';

@AdaptiveAutoRouter(
  routes: [
    AutoRoute(page: EntryPage, initial: true),
    AutoRoute(page: OnboardingPage),
    AutoRoute(page: DailyBriefPage),
    CustomRoute(
      page: TopicPage,
      customRouteBuilder: fadePageRouteBuilder,
    ),
    dashboardTabRouter,
  ],
)
class $MainRouter {}

const dashboardTabRouter = AutoRoute(
  page: MainPage,
  children: [
    AutoRoute(
      path: 'todayTab',
      name: 'TodayTabGroupRouter',
      page: EmptyRouterPage,
      children: [
        AutoRoute(path: '', page: TodayPage),
        RedirectRoute(path: '*', redirectTo: ''),
      ],
    ),
    AutoRoute(
      path: 'exploreTab',
      name: 'ExploreTabGroupRouter',
      page: EmptyRouterPage,
      children: [
        AutoRoute(path: '', page: ExplorePage),
        RedirectRoute(path: '*', redirectTo: ''),
      ],
    ),
    AutoRoute(
      path: 'myReadsTab',
      name: 'MyReadsTabGroupRouter',
      page: EmptyRouterPage,
      children: [
        AutoRoute(path: '', page: MyReadsPage),
        RedirectRoute(path: '*', redirectTo: ''),
      ],
    ),
  ],
);
