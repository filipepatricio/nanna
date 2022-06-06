import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/daily_brief_page.dart';
import 'package:better_informed_mobile/presentation/page/entry/entry_page.dart';
import 'package:better_informed_mobile/presentation/page/explore/explore_page.dart';
import 'package:better_informed_mobile/presentation/page/explore/see_all/article/article_see_all_page.dart';
import 'package:better_informed_mobile/presentation/page/explore/see_all/topics/topics_see_all_page.dart';
import 'package:better_informed_mobile/presentation/page/main/main_page.dart';
import 'package:better_informed_mobile/presentation/page/media/media_item_page.dart';
import 'package:better_informed_mobile/presentation/page/onboarding/onboarding_page.dart';
import 'package:better_informed_mobile/presentation/page/photo_caption/photo_caption_page.dart';
import 'package:better_informed_mobile/presentation/page/profile/profile_page.dart';
import 'package:better_informed_mobile/presentation/page/settings/account/settings_account_page.dart';
import 'package:better_informed_mobile/presentation/page/settings/main/settings_main_page.dart';
import 'package:better_informed_mobile/presentation/page/settings/notifications/settings_notifications_page.dart';
import 'package:better_informed_mobile/presentation/page/sign_in/sign_in_page.dart';
import 'package:better_informed_mobile/presentation/page/tab_bar/tab_bar_page.dart';
import 'package:better_informed_mobile/presentation/page/topic/owner/how_do_we_curate_content_page.dart';
import 'package:better_informed_mobile/presentation/page/topic/owner/topic_owner_page.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_page.dart';
import 'package:better_informed_mobile/presentation/routing/custom_route/bottom_sheet_route_builders.dart';
import 'package:better_informed_mobile/presentation/routing/custom_route/fade_page_route.dart';
import 'package:better_informed_mobile/presentation/util/placeholder_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const topicsPathSegment = 'topics';
const articlePathSegment = 'articles';

final GlobalKey<NavigatorState> mainRouterKey = GlobalKey(debugLabel: 'mainRouterKey');

@AdaptiveAutoRouter(
  routes: [
    CustomRoute(page: EntryPage, initial: true, customRouteBuilder: fadePageRouteBuilder),
    AutoRoute(page: OnboardingPage),
    AutoRoute(page: SignInPage),
    AutoRoute(page: SettingsMainPage),
    AutoRoute(page: SettingsNotificationsPage),
    AutoRoute(page: SettingsAccountPage),
    mainPageRoute,
    CustomRoute(page: PlaceholderPage, durationInMilliseconds: 0),
    CustomRoute(
      path: '$articlePathSegment/:articleSlug',
      page: MediaItemPage,
      customRouteBuilder: cupertinoBottomSheetPageRouteBuilder,
    ),
  ],
)
class $MainRouter {}

const mainPageRoute = CustomRoute(
  page: MainPage,
  durationInMilliseconds: 0,
  children: [
    dashboardTabRouter,
    RedirectRoute(path: '', redirectTo: topicsPathSegment),
    AutoRoute(path: '$topicsPathSegment/:topicSlug', page: TopicPage, name: 'TopicPage'),
    CustomRoute(page: TopicOwnerPage, customRouteBuilder: cupertinoBottomSheetPageRouteBuilder),
    CustomRoute(page: HowDoWeCurateContentPage, customRouteBuilder: cupertinoBottomSheetPageRouteBuilder),
    CustomRoute(page: PhotoCaptionPage, customRouteBuilder: modalFullScreenBottomSheetPageRouteBuilder),
    AutoRoute(path: '$articlePathSegment/:articleSlug', page: MediaItemPage),
  ],
);

const dashboardTabRouter = CustomRoute(
  initial: true,
  page: TabBarPage,
  durationInMilliseconds: 0,
  children: [
    AutoRoute(
      name: 'DailyBriefTabGroupRouter',
      page: DailyBriefTopicsPage,
      children: [
        AutoRoute(path: 'daily_brief', page: DailyBriefPage, initial: true),
      ],
    ),
    AutoRoute(
      path: 'explore',
      name: 'ExploreTabGroupRouter',
      page: ExplorePage,
      children: [
        AutoRoute(path: '', page: ExplorePage, initial: true),
        AutoRoute(page: ArticleSeeAllPage),
        AutoRoute(page: TopicsSeeAllPage),
      ],
    ),
    AutoRoute(
      path: 'profile',
      name: 'ProfileTabGroupRouter',
      page: ProfilePage,
      children: [
        AutoRoute(path: '', page: ProfilePage, initial: true),
      ],
    ),
    RedirectRoute(path: '', redirectTo: topicsPathSegment),
  ],
);
