import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'tests/add_interests_page_visual_test.dart' as add_interests_page_visual_test;
import 'tests/app_connectivity_dialog_visual_test.dart' as app_connectivity_dialog_visual_test;
import 'tests/app_update_dialog_visual_test.dart' as app_update_dialog_visual_test;
import 'tests/article_cover_visual_test.dart' as article_cover_visual_test;
import 'tests/article_paywall_view_visual_test.dart' as article_paywall_view_visual_test;
import 'tests/article_text_scale_factor_selector_page_visual_test.dart'
    as article_text_scale_factor_selector_page_visual_test;
import 'tests/articles_see_all_page_visual_test.dart' as articles_see_all_page_visual_test;
import 'tests/audio_page_visual_test.dart' as audio_page_visual_test;
import 'tests/category_page_visual_test.dart' as category_page_visual_test;
import 'tests/daily_brief_page_visual_test.dart' as daily_brief_page_visual_test;
import 'tests/explore_page_visual_test.dart' as explore_page_visual_test;
import 'tests/how_do_we_curate_content_page_visual_test.dart' as how_do_we_curate_content_page_visual_test;
import 'tests/magic_link_view_visual_test.dart' as magic_link_view_visual_test;
import 'tests/media_item_page_visual_test.dart' as media_item_page_visual_test;
import 'tests/onboarding_page_visual_test.dart' as onboarding_page_visual_test;
import 'tests/quote_editor_view_visual_test.dart' as quote_editor_view_visual_test;
import 'tests/release_note_popup_visual_test.dart' as release_note_popup_visual_test;
import 'tests/saved_page_visual_test.dart' as saved_page_visual_test;
import 'tests/settings_account_page_visual_test.dart' as settings_account_page_visual_test;
import 'tests/settings_appearance_page_visual_test.dart' as settings_appearance_page_visual_test;
import 'tests/settings_legal_page_visual_test.dart' as settings_legal_page_visual_test;
import 'tests/settings_main_page_visual_test.dart' as settings_main_page_visual_test;
import 'tests/settings_manage_my_interests_page_visual_test.dart' as settings_manage_my_interests_page_visual_test;
import 'tests/settings_notifications_page_visual_test.dart' as settings_notifications_page_visual_test;
import 'tests/settings_subscription_page_visual_test.dart' as settings_subscription_page_visual_test;
import 'tests/share_article_view_visual_test.dart' as share_article_view_visual_test;
import 'tests/share_options_view_visual_test.dart' as share_options_view_visual_test;
import 'tests/share_quote_view_visual_test.dart' as share_quote_view_visual_test;
import 'tests/share_topic_view_visual_test.dart' as share_topic_view_visual_test;
import 'tests/sign_in_page_visual_test.dart' as sign_in_page_visual_test;
import 'tests/snackbar_view_visual_test.dart' as snackbar_view_visual_test;
import 'tests/subscription_page_visual_test.dart' as subscription_page_visual_test;
import 'tests/subscription_success_page_visual_test.dart' as subscription_success_page_visual_test;
import 'tests/switch_audio_popup_visual_test.dart' as switch_audio_popup_visual_test;
import 'tests/topic_owner_page_visual_test.dart' as topic_owner_page_visual_test;
import 'tests/topic_page_visual_test.dart' as topic_page_visual_test;
import 'tests/topics_see_all_page_visual_test.dart' as topics_see_all_page_visual_test;
import 'visual_test_utils.dart';

// All visual tests must be referenced here to be included in the CI and Screens report workflows

void main() {
  setUp(() {
    themeMode = AdaptiveThemeMode.dark;
  });
  group('switch_audio_popup_visual_test', switch_audio_popup_visual_test.main);
  group('article_cover_visual_test', article_cover_visual_test.main);
  group(
    'article_text_scale_factor_selector_page_visual_test',
    article_text_scale_factor_selector_page_visual_test.main,
  );
  group('article_paywall_view_visual_test', article_paywall_view_visual_test.main);
  group('app_update_dialog_visual_test', app_update_dialog_visual_test.main);
  group('app_connectivity_dialog_visual_test', app_connectivity_dialog_visual_test.main);
  group('articles_see_all_page_visual_test', articles_see_all_page_visual_test.main);
  group('category_page_visual_test', category_page_visual_test.main);
  group('explore_page_visual_test', explore_page_visual_test.main);
  group('magic_link_view_visual_test', magic_link_view_visual_test.main);
  group('media_item_page_visual_test', media_item_page_visual_test.main);
  group('onboarding_page_visual_test', onboarding_page_visual_test.main);
  group('saved_page_visual_test', saved_page_visual_test.main);
  group('quote_editor_view_visual_test', quote_editor_view_visual_test.main);
  group('share_quote_view_visual_test', share_quote_view_visual_test.main);
  group('settings_account_page_visual_test', settings_account_page_visual_test.main);
  group('settings_appearance_page_visual_test', settings_appearance_page_visual_test.main);
  group('settings_main_page_visual_test', settings_main_page_visual_test.main);
  group('settings_manage_my_interests_page_visual_test', settings_manage_my_interests_page_visual_test.main);

  group('settings_notifications_page_visual_test', settings_notifications_page_visual_test.main);
  group('share_article_view_visual_test', share_article_view_visual_test.main);
  group('share_options_view_visual_test', share_options_view_visual_test.main);
  group('share_topic_view_visual_test', share_topic_view_visual_test.main);
  group('sign_in_page_visual_test', sign_in_page_visual_test.main);
  group('daily_brief_page_visual_test', daily_brief_page_visual_test.main);
  group('topic_owner_page_visual_test', topic_owner_page_visual_test.main);
  group('how_do_we_curate_content_page_visual_test', how_do_we_curate_content_page_visual_test.main);
  group('topic_page_visual_test', topic_page_visual_test.main);
  group('topics_see_all_page_visual_test', topics_see_all_page_visual_test.main);
  group('release_note_popup_visual_test', release_note_popup_visual_test.main);
  group('snackbar_view_visual_test', snackbar_view_visual_test.main);
  group('subscription_page_visual_test', subscription_page_visual_test.main);
  group('subscription_success_page_visual_test', subscription_success_page_visual_test.main);
  group('settings_subscription_page_visual_test', settings_subscription_page_visual_test.main);
  group('audio_page_visual_test', audio_page_visual_test.main);
  group('settings_legal_page_visual_test', settings_legal_page_visual_test.main);
  group('add_interests_page_visual_test', add_interests_page_visual_test.main);
}

ThemeMode themeModeFromString(String mode) {
  switch (mode.toLowerCase()) {
    case 'light':
      return ThemeMode.light;
    case 'dark':
      return ThemeMode.dark;
    default:
      throw Exception('Invalid parameter $mode - possible values "light"|"dark".');
  }
}
