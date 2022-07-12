import 'package:better_informed_mobile/data/app_link/app_link_data_source.dart';
import 'package:better_informed_mobile/data/article/api/mapper/publisher_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/audio/mapper/audio_item_mapper.di.dart';
import 'package:better_informed_mobile/data/auth/api/auth_api_data_source.dart';
import 'package:better_informed_mobile/data/auth/api/dto/auth_token_response_dto.dt.dart';
import 'package:better_informed_mobile/data/auth/api/mapper/auth_token_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/auth/api/mapper/login_response_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/auth/api/provider/linkedin/linkedin_credential_data_source.di.dart';
import 'package:better_informed_mobile/data/auth/api/provider/oauth_credential_provider_data_source.di.dart';
import 'package:better_informed_mobile/data/auth/api/refresh_token_service.di.dart';
import 'package:better_informed_mobile/data/auth/app_link/magic_link_parser.di.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/entry_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/image/api/mapper/image_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/onboarding/mapper/onboarding_version_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/onboarding/store/onboarding_database.dart';
import 'package:better_informed_mobile/data/topic/api/mapper/summary_card_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/topic/api/mapper/topic_owner_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/util/app_info_data_source.di.dart';
import 'package:better_informed_mobile/data/util/graphql_response_resolver.di.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_repository.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/track_activity_use_case.di.dart';
import 'package:better_informed_mobile/domain/article/article_repository.dart';
import 'package:better_informed_mobile/domain/audio/audio_repository.dart';
import 'package:better_informed_mobile/domain/auth/auth_store.dart';
import 'package:better_informed_mobile/domain/bookmark/bookmark_change_notifier.di.dart';
import 'package:better_informed_mobile/domain/bookmark/bookmark_remote_repository.dart';
import 'package:better_informed_mobile/domain/daily_brief/use_case/get_current_brief_use_case.di.dart';
import 'package:better_informed_mobile/domain/push_notification/push_notification_repository.dart';
import 'package:better_informed_mobile/domain/push_notification/push_notification_store.dart';
import 'package:better_informed_mobile/domain/push_notification/use_case/incoming_push_data_refresh_stream_use_case.di.dart';
import 'package:better_informed_mobile/domain/release_notes/release_notes_local_repository.dart';
import 'package:better_informed_mobile/domain/release_notes/release_notes_remote_repository.dart';
import 'package:better_informed_mobile/domain/tutorial/use_case/is_tutorial_step_seen_use_case.di.dart';
import 'package:better_informed_mobile/domain/tutorial/use_case/set_tutorial_step_seen_use_case.di.dart';
import 'package:better_informed_mobile/domain/util/app_info_repository.dart';
import 'package:fresh_graphql/fresh_graphql.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mockito/annotations.dart';

const _classes = [
  AudioRepository,
  ArticleRepository,
  AnalyticsRepository,
  TopicOwnerDTOMapper,
  PublisherDTOMapper,
  ImageDTOMapper,
  EntryDTOMapper,
  SummaryCardDTOMapper,
  OnboardingDatabase,
  OnboardingVersionEntityMapper,
  OAuthCredentialProviderDataSource,
  LinkedinCredentialDataSource,
  AuthApiDataSource,
  AuthTokenDTOMapper,
  FreshLink,
  LoginResponseDTOMapper,
  ReleaseNotesRemoteRepository,
  ReleaseNotesLocalRepository,
  AppInfoRepository,
  AuthStore,
  AudioItemMapper,
  GraphQLClient,
  GraphQLResponseResolver,
  RefreshTokenServiceCache,
  AuthTokenResponseDTO,
  AppLinkDataSource,
  MagicLinkParser,
  AppInfoDataSource,
  BookmarkRepository,
  BookmarkChangeNotifier,
  PushNotificationStore,
  PushNotificationRepository,
  GetCurrentBriefUseCase,
  IsTutorialStepSeenUseCase,
  SetTutorialStepSeenUseCase,
  TrackActivityUseCase,
  IncomingPushDataRefreshStreamUseCase,
];

@GenerateMocks(_classes)
// ignore: unused_element
void _() {}
