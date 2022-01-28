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
import 'package:better_informed_mobile/presentation/page/sign_in/sign_in_page.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/todays_topics_page.dart';
import 'package:better_informed_mobile/presentation/page/topic/owner/how_do_we_curate_content_page.dart';
import 'package:better_informed_mobile/presentation/page/topic/owner/topic_owner_page.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_page.dart';
import 'package:better_informed_mobile/presentation/routing/custom_route/cupertino_bottom_sheet_route_builder.dart';
import 'package:better_informed_mobile/presentation/routing/custom_route/fade_page_route.dart';
import 'package:better_informed_mobile/presentation/routing/custom_route/hero_empty_router_page.dart';
import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> mainRouterKey = GlobalKey(debugLabel: 'mainRouterKey');

@AdaptiveAutoRouter(
  routes: [
    CustomRoute(page: EntryPage, initial: true, customRouteBuilder: fadePageRouteBuilder),
    AutoRoute(page: OnboardingPage),
    AutoRoute(page: SignInPage),
    AutoRoute(page: SettingsMainPage),
    AutoRoute(page: SettingsNotificationsPage),
    AutoRoute(page: SettingsAccountPage),
    AutoRoute(page: TopicPage, name: 'TopicOwnerTopicPage'),
    CustomRoute(page: MediaItemPage, customRouteBuilder: cupertinoBottomSheetPageRouteBuilder),
    CustomRoute(page: TopicOwnerPage, customRouteBuilder: cupertinoBottomSheetPageRouteBuilder),
    CustomRoute(page: HowDoWeCurateContentPage, customRouteBuilder: cupertinoBottomSheetPageRouteBuilder),
    dashboardTabRouter,
  ],
)
class $MainRouter {}

const dashboardTabRouter = CustomRoute(
  page: MainPage,
  durationInMilliseconds: 0,
  children: [
    AutoRoute(
      path: 'topics',
      name: 'TodayTabGroupRouter',
      page: HeroEmptyRouterPage,
      children: [
        AutoRoute(path: '', page: TodaysTopicsPage),
        CustomRoute(
          page: TopicPage,
          path: ':topicSlug',
          customRouteBuilder: fadePageRouteBuilder,
          name: 'TodaysTopicsTopicPage',
        ),
        RedirectRoute(path: '', redirectTo: '')
      ],
    ),
    AutoRoute(
      path: 'explore',
      name: 'ExploreTabGroupRouter',
      page: HeroEmptyRouterPage,
      children: [
        AutoRoute(path: '', page: ExplorePage),
        AutoRoute(page: ArticleSeeAllPage),
        AutoRoute(page: TopicsSeeAllPage),
        AutoRoute(page: TopicPage),
      ],
    ),
    AutoRoute(
      path: 'profile',
      name: 'ProfileTabGroupRouter',
      page: HeroEmptyRouterPage,
      children: [
        AutoRoute(path: '', page: ProfilePage),
      ],
    ),
    RedirectRoute(path: '', redirectTo: 'topics'),
  ],
);
