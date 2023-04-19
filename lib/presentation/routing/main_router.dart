import 'package:auto_route/auto_route.dart';
import 'package:auto_route/empty_router_widgets.dart';
import 'package:better_informed_mobile/presentation/page/add_interests/add_interests_page.dart';
import 'package:better_informed_mobile/presentation/page/audio/audio_page.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/daily_brief_page.dart';
import 'package:better_informed_mobile/presentation/page/empty_page.dart';
import 'package:better_informed_mobile/presentation/page/entry/entry_page.dart';
import 'package:better_informed_mobile/presentation/page/explore/categories/category_page.dart';
import 'package:better_informed_mobile/presentation/page/explore/explore_page.dart';
import 'package:better_informed_mobile/presentation/page/explore/see_all/article/article_see_all_page.dart';
import 'package:better_informed_mobile/presentation/page/explore/see_all/topics/topics_see_all_page.dart';
import 'package:better_informed_mobile/presentation/page/main/main_page.dart';
import 'package:better_informed_mobile/presentation/page/media/article_text_scale_factor_selector_page.dart';
import 'package:better_informed_mobile/presentation/page/media/media_item_page.dart';
import 'package:better_informed_mobile/presentation/page/onboarding/onboarding_page.dart';
import 'package:better_informed_mobile/presentation/page/photo_caption/photo_caption_page.dart';
import 'package:better_informed_mobile/presentation/page/saved/saved_page.dart';
import 'package:better_informed_mobile/presentation/page/settings/account/settings_account_page.dart';
import 'package:better_informed_mobile/presentation/page/settings/appearance/settings_appearance_page.dart';
import 'package:better_informed_mobile/presentation/page/settings/legal/settings_privacy_policy_page.dart';
import 'package:better_informed_mobile/presentation/page/settings/legal/settings_terms_of_service_page.dart';
import 'package:better_informed_mobile/presentation/page/settings/main/settings_main_page.dart';
import 'package:better_informed_mobile/presentation/page/settings/manage_my_interests/settings_manage_my_interests_page.dart';
import 'package:better_informed_mobile/presentation/page/settings/notifications/settings_notifications_page.dart';
import 'package:better_informed_mobile/presentation/page/settings/subscription/settings_subscription_page.dart';
import 'package:better_informed_mobile/presentation/page/sign_in/sign_in_page.dart';
import 'package:better_informed_mobile/presentation/page/subscription/subscription_page.dart';
import 'package:better_informed_mobile/presentation/page/subscription/subscription_success_page.dart';
import 'package:better_informed_mobile/presentation/page/tab_bar/tab_bar_page.dart';
import 'package:better_informed_mobile/presentation/page/topic/owner/how_do_we_curate_content_page.dart';
import 'package:better_informed_mobile/presentation/page/topic/owner/topic_owner_page.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_page.dart';
import 'package:better_informed_mobile/presentation/routing/custom_route/bottom_sheet_route_builders.dart';
import 'package:better_informed_mobile/presentation/routing/custom_route/fade_page_route.dart';
import 'package:better_informed_mobile/presentation/util/placeholder_page.dart';

const magicLinkSegment = 'magic';

/// Tabs
const todayTabPath = 'todays_topics';
const exploreTabPath = 'explore';
const profileTabPath = 'profile';
const tabsPaths = [todayTabPath, exploreTabPath, profileTabPath];

/// Main
const topicsPath = 'topics';
const articlePath = 'articles';
const subscribePath = 'subscribe';

/// Settings
const unsubscribeNotificationsPath = 'unsubscribe';
const settingsPath = 'settings';
const notificationsPath = 'notifications';
const appearancePath = 'appearance';
const interestsPath = 'interests';
const accountPath = 'account';
const subscriptionPath = 'subscription';
const termsPagePath = 'terms';
const privacyPagePath = 'privacy';

@AdaptiveAutoRouter(
  routes: [
    CustomRoute(page: EntryPage, initial: true, customRouteBuilder: fadePageRouteBuilder),
    AutoRoute(page: OnboardingPage),
    AutoRoute(page: SignInPage),
    CustomRoute(
      name: 'SignInPageModal',
      page: SignInPage,
      customRouteBuilder: modalBottomSheetPageRouteBuilder,
    ),
    CustomRoute(
      path: subscribePath,
      page: SubscriptionPage,
      customRouteBuilder: modalBottomSheetPageRouteBuilder,
    ),
    mainPageRoute,
    CustomRoute(page: PlaceholderPage, durationInMilliseconds: 0),
    AutoRoute(page: EmptyPage),
    AutoRoute(path: privacyPagePath, page: SettingsPrivacyPolicyPage),
    AutoRoute(path: termsPagePath, page: SettingsTermsOfServicePage),
  ],
)
class $MainRouter {}

const mainPageRoute = CustomRoute(
  page: MainPage,
  durationInMilliseconds: 0,
  children: [
    dashboardTabRouter,
    RedirectRoute(path: '', redirectTo: topicsPath),
    AutoRoute(
      path: '$topicsPath/:topicSlug',
      name: 'TopicPage',
      page: TopicPage,
    ),
    CustomRoute(page: TopicOwnerPage, customRouteBuilder: modalBottomSheetPageRouteBuilder),
    CustomRoute(page: AddInterestsPage, customRouteBuilder: modalBottomSheetPageRouteBuilder),
    CustomRoute(
      path: subscribePath,
      page: SubscriptionPage,
      customRouteBuilder: modalBottomSheetPageRouteBuilder,
    ),
    CustomRoute(page: SubscriptionSuccessPage, customRouteBuilder: modalBottomSheetPageRouteBuilder),
    CustomRoute(page: HowDoWeCurateContentPage, customRouteBuilder: modalBottomSheetPageRouteBuilder),
    CustomRoute(page: PhotoCaptionPage, customRouteBuilder: modalFullScreenBottomSheetPageRouteBuilder),
    CustomRoute(
      page: ArticleTextScaleFactorSelectorPage,
      customRouteBuilder: modalBottomSheetPageTransparentRouteBuilder,
    ),
    AutoRoute(path: '$articlePath/:articleSlug', page: MediaItemPage),
    AutoRoute(page: CategoryPage),
    CustomRoute(
      page: AudioPage,
      customRouteBuilder: modalFullScreenBottomSheetPageRouteBuilder,
    ),
    AutoRoute(path: settingsPath, page: SettingsMainPage),
    AutoRoute(path: notificationsPath, page: SettingsNotificationsPage),
    AutoRoute(path: appearancePath, page: SettingsAppearancePage),
    AutoRoute(path: interestsPath, page: SettingsManageMyInterestsPage),
    AutoRoute(path: accountPath, page: SettingsAccountPage),
  ],
);

const dashboardTabRouter = CustomRoute(
  initial: true,
  page: TabBarPage,
  durationInMilliseconds: 0,
  children: [
    AutoRoute(
      path: todayTabPath,
      name: 'DailyBriefTabGroupRouter',
      page: EmptyRouterPage,
      children: [
        AutoRoute(path: '', page: DailyBriefPage, initial: true),
      ],
    ),
    AutoRoute(
      path: exploreTabPath,
      name: 'ExploreTabGroupRouter',
      page: EmptyRouterPage,
      children: [
        AutoRoute(path: '', page: ExplorePage, initial: true),
        AutoRoute(page: ArticleSeeAllPage),
        AutoRoute(page: TopicsSeeAllPage),
        AutoRoute(page: CategoryPage),
      ],
    ),
    AutoRoute(
      path: profileTabPath,
      name: 'ProfileTabGroupRouter',
      page: EmptyRouterPage,
      children: [
        AutoRoute(path: '', page: SavedPage, initial: true),
        AutoRoute(path: settingsPath, page: SettingsMainPage),
        AutoRoute(path: notificationsPath, page: SettingsNotificationsPage),
        AutoRoute(path: appearancePath, page: SettingsAppearancePage),
        AutoRoute(path: accountPath, page: SettingsAccountPage),
        AutoRoute(path: interestsPath, page: SettingsManageMyInterestsPage),
        AutoRoute(path: subscriptionPath, page: SettingsSubscriptionPage),
        AutoRoute(path: privacyPagePath, page: SettingsPrivacyPolicyPage),
        AutoRoute(path: termsPagePath, page: SettingsTermsOfServicePage),
      ],
    ),
    RedirectRoute(path: '', redirectTo: topicsPath),
  ],
);
