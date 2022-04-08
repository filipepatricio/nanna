import 'package:flutter_test/flutter_test.dart';

import 'data/audio/mapper/audio_playback_state_mapper_test.dart' as audio_playback_state_mapper_test;
import 'data/auth/api/auth_repository_impl_test.dart' as auth_repository_impl_test;
import 'data/auth/api/refresh_token_service_test.dart' as refresh_token_service_test;
import 'data/auth/app_link/auth_app_link_repository_impl_test.dart' as auth_app_link_repository_impl_test;
import 'data/auth/app_link/magic_link_parser_test.dart' as magic_link_parser_test;
import 'data/networking/app_version_link/app_version_link_transformer_test.dart' as app_version_link_transformer_test;
import 'data/networking/should_refresh_validator_test.dart' as should_refresh_validator_test;

import 'domain/audio/prepare_audio_track_use_case_test.dart' as prepare_audio_track_use_case_test;
import 'domain/bookmark/use_case/get_bookmark_state_use_case_test.dart' as get_bookmark_state_use_case_test;
import 'domain/bookmark/use_case/switch_bookmark_state_use_case_test.dart' as switch_bookmark_state_use_case_test;
import 'domain/push_notification/use_case/maybe_register_push_notification_token_use_case_test.dart'
    as maybe_register_push_notification_token_use_case_test;
import 'domain/push_notification/use_case/set_channel_email_setting_use_case_test.dart'
    as set_channel_email_setting_use_case_test;
import 'domain/push_notification/use_case/set_channel_push_setting_use_case_test.dart'
    as set_channel_push_setting_use_case_test;

import 'presentation/app_update_checker_test.dart' as app_update_checker_test;
import 'presentation/media_item_page_test.dart' as media_item_page_test;
import 'presentation/sign_in_page_test.dart' as sign_in_page_test;
import 'presentation/topic_owner_page_test.dart' as topic_owner_page_test;

// All unit tests must be referenced here to be included in the CI workflow

void main() {
  // Data
  group('audio_playback_state_mapper_test', audio_playback_state_mapper_test.main);
  group('auth_repository_impl_test', auth_repository_impl_test.main);
  group('refresh_token_service_test', refresh_token_service_test.main);
  group('auth_app_link_repository_impl_test', auth_app_link_repository_impl_test.main);
  group('magic_link_parser_test', magic_link_parser_test.main);
  group('app_version_link_transformer_test', app_version_link_transformer_test.main);
  group('should_refresh_validator_test', should_refresh_validator_test.main);

  // Domain
  group('prepare_audio_track_use_case_test', prepare_audio_track_use_case_test.main);
  group('get_bookmark_state_use_case_test', get_bookmark_state_use_case_test.main);
  group('switch_bookmark_state_use_case_test', switch_bookmark_state_use_case_test.main);
  group(
    'maybe_register_push_notification_token_use_case_test',
    maybe_register_push_notification_token_use_case_test.main,
  );
  group('set_channel_email_setting_use_case_test', set_channel_email_setting_use_case_test.main);
  group('set_channel_push_setting_use_case_test', set_channel_push_setting_use_case_test.main);

  // Presentation
  group('app_update_checker_test', app_update_checker_test.main);
  group('media_item_page_test', media_item_page_test.main);
  group('sign_in_page_test', sign_in_page_test.main);
  group('topic_owner_page_test', topic_owner_page_test.main);
}