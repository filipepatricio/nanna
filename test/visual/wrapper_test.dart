import 'package:flutter_test/flutter_test.dart';

import 'tests/app_update_dialog_visual_test.dart' as app_update_dialog_visual_test;
import 'tests/articles_see_all_page_visual_test.dart' as articles_see_all_page_visual_test;
import 'tests/explore_page_visual_test.dart' as explore_page_visual_test;
import 'tests/invite_friend_page_visual_test.dart' as invite_friend_page_visual_test;
import 'tests/magic_link_view_visual_test.dart' as magic_link_view_visual_test;
import 'tests/media_item_page_visual_test.dart' as media_item_page_visual_test;
import 'tests/no_member_access_page_visual_test.dart' as no_member_access_page_visual_test;
import 'tests/onboarding_page_visual_test.dart' as onboarding_page_visual_test;
import 'tests/profile_page_visual_test.dart' as profile_page_visual_test;
import 'tests/quote_background_view_visual_test.dart' as quote_background_view_visual_test;
import 'tests/quote_editor_view_visual_test.dart' as quote_editor_view_visual_test;
import 'tests/quote_foreground_view_visual_test.dart' as quote_foreground_view_visual_test;
import 'tests/reading_list_article_select_view_visual_test.dart' as reading_list_article_select_view_visual_test;
import 'tests/settings_account_page_visual_test.dart' as settings_account_page_visual_test;
import 'tests/settings_main_page_visual_test.dart' as settings_main_page_visual_test;
import 'tests/settings_notifications_page_visual_test.dart' as settings_notifications_page_visual_test;
import 'tests/share_article_view_visual_test.dart' as share_article_view_visual_test;
import 'tests/share_reading_list_view_visual_test.dart' as share_reading_list_view_visual_test;
import 'tests/sign_in_page_visual_test.dart' as sign_in_page_visual_test;
import 'tests/todays_topics_page_visual_test.dart' as todays_topics_page_visual_test;
import 'tests/topic_owner_page_visual_test.dart' as topic_owner_page_visual_test;
import 'tests/topic_page_visual_test.dart' as topic_page_visual_test;
import 'tests/topics_see_all_page_visual_test.dart' as topics_see_all_page_visual_test;

// All visual tests must be referenced here to be included in the CI and Screens report workflows

void main() {
  group('app_update_dialog_visual_test', app_update_dialog_visual_test.main);
  group('articles_see_all_page_visual_test', articles_see_all_page_visual_test.main);
  group('explore_page_visual_test', explore_page_visual_test.main);
  group('invite_friend_page_visual_test', invite_friend_page_visual_test.main);
  group('magic_link_view_visual_test', magic_link_view_visual_test.main);
  group('media_item_page_visual_test', media_item_page_visual_test.main);
  group('no_member_access_page_visual_test', no_member_access_page_visual_test.main);
  group('onboarding_page_visual_test', onboarding_page_visual_test.main);
  group('profile_page_visual_test', profile_page_visual_test.main);
  group('quote_background_view_visual_test', quote_background_view_visual_test.main);
  group('quote_editor_view_visual_test', quote_editor_view_visual_test.main);
  group('quote_foreground_view_visual_test', quote_foreground_view_visual_test.main);
  group('reading_list_article_select_view_visual_test', reading_list_article_select_view_visual_test.main);
  group('settings_account_page_visual_test', settings_account_page_visual_test.main);
  group('settings_main_page_visual_test', settings_main_page_visual_test.main);
  group('settings_notifications_page_visual_test', settings_notifications_page_visual_test.main);
  group('share_article_view_visual_test', share_article_view_visual_test.main);
  group('share_reading_list_view_visual_test', share_reading_list_view_visual_test.main);
  group('sign_in_page_visual_test', sign_in_page_visual_test.main);
  group('todays_topics_page_visual_test', todays_topics_page_visual_test.main);
  group('topic_owner_page_visual_test', topic_owner_page_visual_test.main);
  group('topic_page_visual_test', topic_page_visual_test.main);
  group('topics_see_all_page_visual_test', topics_see_all_page_visual_test.main);
}
