import 'package:flutter_test/flutter_test.dart';

import 'tests/data/audio/mapper/audio_item_mapper_test.dart' as audio_item_mapper_test;
import 'tests/data/audio/mapper/audio_playback_state_mapper_test.dart' as audio_playback_state_mapper_test;
import 'tests/data/auth/api/auth_repository_impl_test.dart' as auth_repository_impl_test;
import 'tests/data/auth/api/refresh_token_service_test.dart' as refresh_token_service_test;
import 'tests/data/auth/app_link/auth_app_link_repository_impl_test.dart' as auth_app_link_repository_impl_test;
import 'tests/data/auth/app_link/magic_link_parser_test.dart' as magic_link_parser_test;
import 'tests/data/exception/common_exception_mapper_test.dart' as common_exception_mapper_test;
import 'tests/data/exception/firebase_exception_mapper_test.dart' as firebase_exception_mapper_test;
import 'tests/data/exception/unknown_exception_unwrap_mapper_test.dart' as unknown_exception_unwrap_mapper_test;
import 'tests/data/images/cloudinary_test.dart' as cloudinary_test;
import 'tests/data/networking/app_version_link/app_version_link_transformer_test.dart'
    as app_version_link_transformer_test;
import 'tests/data/networking/should_refresh_validator_test.dart' as should_refresh_validator_test;
import 'tests/data/push_notificaton/push_notification_repository_impl_test.dart'
    as push_notification_repository_impl_test;
import 'tests/data/subscription/exception/purchase_exception_resolver_test.dart' as purchase_exception_resolver_test;
import 'tests/data/subscription/mapper/active_subscription_mapper_test.dart' as active_subscription_mapper_test;
import 'tests/data/subscription/purchase_repository_impl_test.dart' as purchase_repository_impl_test;
import 'tests/data/topic/api/mapper/topic_dto_mapper_test.dart' as topic_dto_mapper_test;
import 'tests/data/topic/api/mapper/topic_preview_dto_mapper_test.dart' as topic_preview_dto_mapper_test;
import 'tests/domain/article/use_case/save_article_read_progress_locally_use_case_test.dart'
    as save_article_read_progress_locally_use_case_test;
import 'tests/domain/article/use_case/synchroniza_article_progress_with_remote_use_case_test.dart'
    as synchroniza_article_progress_with_remote_use_case_test;
import 'tests/domain/article/use_case/track_article_reading_progress_use_case_test.dart'
    as track_article_reading_progress_use_case_test;
import 'tests/domain/audio/audio_progress_tracker_test.dart' as audio_progress_tracker_test;
import 'tests/domain/audio/informed_audio_handler_test.dart' as informed_audio_handler_test;
import 'tests/domain/audio/prepare_audio_track_use_case_test.dart' as prepare_audio_track_use_case_test;
import 'tests/domain/bookmark/use_case/add_bookmark_use_case_test.dart' as add_bookmark_use_case_test;
import 'tests/domain/bookmark/use_case/get_bookmark_state_use_case_test.dart' as get_bookmark_state_use_case_test;
import 'tests/domain/bookmark/use_case/remove_bookmark_use_case_test.dart' as remove_bookmark_use_case_test;
import 'tests/domain/bookmark/use_case/save_bookmarked_media_item_use_case_test.dart'
    as save_bookmarked_media_item_use_case_test;
import 'tests/domain/bookmark/use_case/switch_bookmark_state_use_case_test.dart' as switch_bookmark_state_use_case_test;
import 'tests/domain/daily_brief/use_case/mark_entry_as_seen_use_case_test.dart' as mark_entry_as_seen_use_case_test;
import 'tests/domain/daily_brief_badge/should_show_daily_brief_badge_use_case_test.dart'
    as should_show_daily_brief_badge_use_case_test;
import 'tests/domain/general/app_initialization_test.dart' as app_initialization_test;
import 'tests/domain/general/article_read_state_notifier_test.dart' as article_read_state_notifier_test;
import 'tests/domain/push_notification/use_case/maybe_register_push_notification_token_use_case_test.dart'
    as maybe_register_push_notification_token_use_case_test;
import 'tests/domain/push_notification/use_case/set_channel_email_setting_use_case_test.dart'
    as set_channel_email_setting_use_case_test;
import 'tests/domain/push_notification/use_case/set_channel_push_setting_use_case_test.dart'
    as set_channel_push_setting_use_case_test;
import 'tests/domain/release_notes/use_case/get_current_release_note_use_case_test.dart'
    as get_current_release_note_use_case_test;
import 'tests/domain/release_notes/use_case/save_release_note_if_first_run_use_case_test.dart'
    as save_release_note_if_first_run_use_case_test;
import 'tests/domain/subscription/data/subscription_plan_group_test.dart' as subscription_plan_group_test;
import 'tests/domain/synchronization/use_case/run_initial_bookmark_sync_use_case_test.dart'
    as run_initial_bookmark_sync_use_case_test;
import 'tests/domain/synchronization/use_case/save_synchronizable_item_use_case_test.dart'
    as save_synchronizable_item_use_case_test;
import 'tests/domain/synchronization/use_case/synchroniza_all_use_case_test.dart' as synchroniza_all_use_case_test;
import 'tests/presentation/app_connectivity_checker_test.dart' as app_connectivity_checker_test;
import 'tests/presentation/app_update_checker_test.dart' as app_update_checker_test;
import 'tests/presentation/article_paywall_view_test.dart' as article_paywall_view_test;
import 'tests/presentation/audio_page_test.dart' as audio_page_test;
import 'tests/presentation/daily_brief_page_test.dart' as daily_brief_page_test;
import 'tests/presentation/entry_page_test.dart' as entry_page_test;
import 'tests/presentation/explore_page_test.dart' as explore_page_test;
import 'tests/presentation/main_page_test.dart' as main_page_test;
import 'tests/presentation/media_item_page_test.dart' as media_item_page_test;
import 'tests/presentation/onboarding_page_test.dart' as onboarding_page_test;
import 'tests/presentation/profile_page_test.dart' as profile_page_test;
import 'tests/presentation/settings_appearance_page_test.dart' as settings_appearance_page_test;
import 'tests/presentation/sign_in_page_test.dart' as sign_in_page_test;
import 'tests/presentation/subscription_page_test.dart' as subscription_page_test;
import 'tests/presentation/topic_owner_page_test.dart' as topic_owner_page_test;
import 'tests/presentation/util/date_format_util_test.dart' as date_format_util_test;
import 'tests/presentation/widget/audio/audio_banner_test.dart' as audio_banner_test;
import 'tests/presentation/widget/audio/progress_bar/audio_progress_bar_cubit_test.dart'
    as audio_progress_bar_cubit_test;
import 'tests/presentation/widget/subscription/settings_subscription_page_cubit_test.dart'
    as settings_subscription_page_cubit_test;
import 'tests/presentation/widget/subscription/subscription_card_cubit_test.dart' as subscription_card_cubit_test;

// All unit tests must be referenced here to be included in the CI workflow

void main() {
  // Data
  group('audio_item_mapper_test', audio_item_mapper_test.main);
  group('topic_dto_mapper_test', topic_dto_mapper_test.main);
  group('topic_preview_dto_mapper_test', topic_preview_dto_mapper_test.main);
  group('audio_playback_state_mapper_test', audio_playback_state_mapper_test.main);
  group('audio_progress_tracker_test', audio_progress_tracker_test.main);
  group('auth_repository_impl_test', auth_repository_impl_test.main);
  group('refresh_token_service_test', refresh_token_service_test.main);
  group('auth_app_link_repository_impl_test', auth_app_link_repository_impl_test.main);
  group('magic_link_parser_test', magic_link_parser_test.main);
  group('app_version_link_transformer_test', app_version_link_transformer_test.main);
  group('should_refresh_validator_test', should_refresh_validator_test.main);
  group('cloudinary_test', cloudinary_test.main);
  group('active_subscription_mapper_test', active_subscription_mapper_test.main);
  group('common_exception_mapper_test', common_exception_mapper_test.main);
  group('unknown_exception_unwrap_mapper_test', unknown_exception_unwrap_mapper_test.main);
  group('purchase_exception_resolver_test', purchase_exception_resolver_test.main);
  group('purchase_repository_impl_test', purchase_repository_impl_test.main);
  group('push_notification_repository_impl_test', push_notification_repository_impl_test.main);
  group('firebase_exception_mapper_test', firebase_exception_mapper_test.main);

  // Domain
  group('get_current_release_note_use_case_test', get_current_release_note_use_case_test.main);
  group('save_release_note_if_first_run_use_case_test', save_release_note_if_first_run_use_case_test.main);
  group('prepare_audio_track_use_case_test', prepare_audio_track_use_case_test.main);
  group('get_bookmark_state_use_case_test', get_bookmark_state_use_case_test.main);
  group('switch_bookmark_state_use_case_test', switch_bookmark_state_use_case_test.main);
  group(
    'maybe_register_push_notification_token_use_case_test',
    maybe_register_push_notification_token_use_case_test.main,
  );
  group('set_channel_email_setting_use_case_test', set_channel_email_setting_use_case_test.main);
  group('set_channel_push_setting_use_case_test', set_channel_push_setting_use_case_test.main);
  group('article_paywall_view_test', article_paywall_view_test.main);
  group('track_article_reading_progress_use_case_test', track_article_reading_progress_use_case_test.main);
  group('article_read_state_notifier_test', article_read_state_notifier_test.main);
  group('add_bookmark_use_case_test', add_bookmark_use_case_test.main);
  group('remove_bookmark_use_case_test', remove_bookmark_use_case_test.main);
  group('save_bookmarked_media_item_use_case_test', save_bookmarked_media_item_use_case_test.main);
  group('synchroniza_all_use_case_test', synchroniza_all_use_case_test.main);
  group('run_initial_bookmark_sync_use_case_test', run_initial_bookmark_sync_use_case_test.main);
  group('save_article_read_progress_locally_use_case_test', save_article_read_progress_locally_use_case_test.main);
  group(
    'synchroniza_article_progress_with_remote_use_case_test',
    synchroniza_article_progress_with_remote_use_case_test.main,
  );
  group('subscription_plan_group_test', subscription_plan_group_test.main);
  group('save_synchronizable_item_use_case_test', save_synchronizable_item_use_case_test.main);
  group('informed_audio_handler_test', informed_audio_handler_test.main);
  group('mark_entry_as_seen_use_case_test', mark_entry_as_seen_use_case_test.main);
  group('app_initialization_test', app_initialization_test.main);

  // Presentation
  group('app_connectivity_checker_test', app_connectivity_checker_test.main);
  group('app_update_checker_test', app_update_checker_test.main);
  group('daily_brief_page_test', daily_brief_page_test.main);
  group('explore_page_test', explore_page_test.main);
  group('main_page_test', main_page_test.main);
  group('media_item_page_test', media_item_page_test.main);
  group('sign_in_page_test', sign_in_page_test.main);
  group('topic_owner_page_test', topic_owner_page_test.main);
  group('date_format_util_test', date_format_util_test.main);
  group('audio_progress_bar_cubit_test', audio_progress_bar_cubit_test.main);
  group('subscription_page_test', subscription_page_test.main);
  group('audio_page_test', audio_page_test.main);
  group('audio_banner_test', audio_banner_test.main);
  group('subscription_card_cubit_test', subscription_card_cubit_test.main);
  group('settings_subscription_page_cubit_test', settings_subscription_page_cubit_test.main);
  group('onboarding_page_test', onboarding_page_test.main);
  group('profile_page_test', profile_page_test.main);
  group('should_show_daily_brief_badge_use_case_test', should_show_daily_brief_badge_use_case_test.main);
  group('settings_appearance_page_test', settings_appearance_page_test.main);
  group('entry_page_test', entry_page_test.main);
}
