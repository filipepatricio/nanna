import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/presentation/page/entry/entry_page.dart';
import 'package:better_informed_mobile/presentation/page/explore_tab/explore_page.dart';
import 'package:better_informed_mobile/presentation/page/explore_tab/see_all/article/article_see_all_page.dart';
import 'package:better_informed_mobile/presentation/page/explore_tab/see_all/topics/topics_see_all_page.dart';
import 'package:better_informed_mobile/presentation/page/main/main_page.dart';
import 'package:better_informed_mobile/presentation/page/media/media_item_page.dart';
import 'package:better_informed_mobile/presentation/page/onboarding/onboarding_page.dart';
import 'package:better_informed_mobile/presentation/page/profile_tab/profile_page.dart';
import 'package:better_informed_mobile/presentation/page/settings/account/settings_account_page.dart';
import 'package:better_informed_mobile/presentation/page/settings/main/settings_main_page.dart';
import 'package:better_informed_mobile/presentation/page/settings/notifications/settings_notifications_page.dart';
import 'package:better_informed_mobile/presentation/page/settings/policy_terms/settings_policy_terms_page.dart';
import 'package:better_informed_mobile/presentation/page/sign_in/sign_in_page.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/todays_topics_page.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_page.dart';
import 'package:better_informed_mobile/presentation/routing/custom_route/cupertino_bottom_sheet_route_builder.dart';
import 'package:better_informed_mobile/presentation/routing/custom_route/fade_page_route.dart';
import 'package:better_informed_mobile/presentation/routing/custom_route/hero_empty_router_page.dart';

@AdaptiveAutoRouter(
  routes: [
    CustomRoute(page: EntryPage, initial: true, customRouteBuilder: fadePageRouteBuilder),
    AutoRoute(page: OnboardingPage),
    AutoRoute(page: SignInPage),
    AutoRoute(page: SettingsMainPage),
    AutoRoute(page: SettingsPolicyTermsPage),
    AutoRoute(page: SettingsNotificationsPage),
    AutoRoute(page: SettingsAccountPage),
    CustomRoute(page: MediaItemPage, customRouteBuilder: cupertinoBottomSheetPageRouteBuilder),
    dashboardTabRouter,
  ],
)
class $MainRouter {}

const dashboardTabRouter = CustomRoute(
  page: MainPage,
  durationInMilliseconds: 0,
  children: [
    AutoRoute(
      path: 'todayTab',
      name: 'TodayTabGroupRouter',
      page: HeroEmptyRouterPage,
      children: [
        AutoRoute(path: '', page: TodaysTopicsPage),
        CustomRoute(page: TopicPage, customRouteBuilder: fadePageRouteBuilder, name: 'TodaysTopicsTopicPage'),
        RedirectRoute(path: '*', redirectTo: ''),
      ],
    ),
    AutoRoute(
      path: 'exploreTab',
      name: 'ExploreTabGroupRouter',
      page: HeroEmptyRouterPage,
      children: [
        AutoRoute(path: '', page: ExplorePage),
        AutoRoute(page: ArticleSeeAllPage),
        AutoRoute(page: TopicsSeeAllPage),
        AutoRoute(page: TopicPage),
        RedirectRoute(path: '*', redirectTo: ''),
      ],
    ),
    AutoRoute(
      path: 'profileTab',
      name: 'ProfileTabGroupRouter',
      page: HeroEmptyRouterPage,
      children: [
        AutoRoute(path: '', page: ProfilePage),
        RedirectRoute(path: '*', redirectTo: ''),
      ],
    ),
  ],
);
