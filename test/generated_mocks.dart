import 'package:better_informed_mobile/data/app_link/app_link_data_source.dart';
import 'package:better_informed_mobile/data/article/api/mapper/publisher_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/audio/mapper/audio_item_mapper.di.dart';
import 'package:better_informed_mobile/data/auth/api/auth_api_data_source.dart';
import 'package:better_informed_mobile/data/auth/api/dto/auth_token_response_dto.dt.dart';
import 'package:better_informed_mobile/data/auth/api/mapper/auth_token_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/auth/api/mapper/login_response_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/auth/api/provider/apple_credential_data_source.di.dart';
import 'package:better_informed_mobile/data/auth/api/provider/google_credential_data_source.di.dart';
import 'package:better_informed_mobile/data/auth/api/provider/linkedin/linkedin_credential_data_source.di.dart';
import 'package:better_informed_mobile/data/auth/api/provider/oauth_credential_provider_data_source.di.dart';
import 'package:better_informed_mobile/data/auth/api/refresh_token_service.di.dart';
import 'package:better_informed_mobile/data/auth/app_link/magic_link_parser.di.dart';
import 'package:better_informed_mobile/data/categories/mapper/category_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/common/mapper/curation_info_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/common/mapper/curator_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/entry_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/exception/firebase/firebase_exception_mapper.di.dart';
import 'package:better_informed_mobile/data/image/api/mapper/image_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/onboarding/mapper/onboarding_version_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/onboarding/store/onboarding_database.dart';
import 'package:better_informed_mobile/data/push_notification/api/mapper/notification_channel_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/push_notification/api/mapper/notification_preferences_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/push_notification/api/mapper/registered_push_token_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/push_notification/api/push_notification_api_data_source.dart';
import 'package:better_informed_mobile/data/push_notification/incoming_push/mapper/incoming_push_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/push_notification/push_notification_messenger.di.dart';
import 'package:better_informed_mobile/data/subscription/purchase_remote_data_source.di.dart';
import 'package:better_informed_mobile/data/topic/api/mapper/topic_publisher_information_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/util/app_info_data_source.di.dart';
import 'package:better_informed_mobile/data/util/graphql_response_resolver.di.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_repository.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/track_activity_use_case.di.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/article/article_repository.dart';
import 'package:better_informed_mobile/domain/article/use_case/get_article_audio_progress_use_case.di.dart';
import 'package:better_informed_mobile/domain/audio/audio_repository.dart';
import 'package:better_informed_mobile/domain/audio/use_case/audio_playback_state_stream_use_case.di.dart';
import 'package:better_informed_mobile/domain/audio/use_case/audio_position_seek_use_case.di.dart';
import 'package:better_informed_mobile/domain/audio/use_case/audio_position_stream_use_case.di.dart';
import 'package:better_informed_mobile/domain/auth/auth_store.dart';
import 'package:better_informed_mobile/domain/bookmark/bookmark_change_notifier.di.dart';
import 'package:better_informed_mobile/domain/bookmark/bookmark_remote_repository.dart';
import 'package:better_informed_mobile/domain/daily_brief/use_case/get_current_brief_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/use_case/get_past_brief_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/use_case/get_should_update_brief_stream_use_case.di.dart';
import 'package:better_informed_mobile/domain/deep_link/deep_link_repository.dart';
import 'package:better_informed_mobile/domain/feature_flags/feature_flags_repository.dart';
import 'package:better_informed_mobile/domain/feature_flags/use_case/should_use_paid_subscriptions_use_case.di.dart';
import 'package:better_informed_mobile/domain/general/get_should_update_article_progress_state_use_case.di.dart';
import 'package:better_informed_mobile/domain/push_notification/push_notification_repository.dart';
import 'package:better_informed_mobile/domain/push_notification/push_notification_store.dart';
import 'package:better_informed_mobile/domain/push_notification/use_case/incoming_push_data_refresh_stream_use_case.di.dart';
import 'package:better_informed_mobile/domain/release_notes/release_notes_local_repository.dart';
import 'package:better_informed_mobile/domain/release_notes/release_notes_remote_repository.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';
import 'package:better_informed_mobile/domain/subscription/mapper/active_subscription_mapper.di.dart';
import 'package:better_informed_mobile/domain/subscription/mapper/subscription_plan_mapper.di.dart';
import 'package:better_informed_mobile/domain/subscription/purchases_repository.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_active_subscription_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_preferred_subscription_plan_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_subscription_plans_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/has_active_subscription_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/is_onboarding_paywall_seen_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/purchase_subscription_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/set_onboarding_paywall_seen_use_case.di.dart';
import 'package:better_informed_mobile/domain/tutorial/use_case/is_tutorial_step_seen_use_case.di.dart';
import 'package:better_informed_mobile/domain/tutorial/use_case/set_tutorial_step_seen_use_case.di.dart';
import 'package:better_informed_mobile/domain/util/app_info_repository.dart';
import 'package:better_informed_mobile/domain/util/network_cache_manager.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fresh_graphql/fresh_graphql.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mockito/annotations.dart';
import 'package:purchases_flutter/object_wrappers.dart';

const _classes = [
  AudioRepository,
  ArticleRepository,
  AnalyticsRepository,
  CuratorDTOMapper,
  PublisherDTOMapper,
  ImageDTOMapper,
  EntryDTOMapper,
  TopicPublisherInformationDTOMapper,
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
  GetPastBriefUseCase,
  AudioPlaybackStateStreamUseCase,
  AudioPositionStreamUseCase,
  AudioPositionSeekUseCase,
  GetArticleAudioProgressUseCase,
  GetShouldUpdateBriefStreamUseCase,
  ShouldUsePaidSubscriptionsUseCase,
  IsOnboardingPaywallSeenUseCase,
  HasActiveSubscriptionUseCase,
  SetOnboardingPaywallSeenUseCase,
  PurchasesRepository,
  GetPreferredSubscriptionPlanUseCase,
  PurchaseSubscriptionUseCase,
  FeaturesFlagsRepository,
  NetworkCacheManager,
  CustomerInfo,
  SubscriptionPlan,
  GetActiveSubscriptionUseCase,
  GetSubscriptionPlansUseCase,
  CategoryDTOMapper,
  DeepLinkRepository,
  CurationInfoDTOMapper,
  AppConfig,
  SubscriptionPlanMapper,
  ActiveSubscriptionMapper,
  PurchaseRemoteDataSource,
  FirebaseMessaging,
  PushNotificationApiDataSource,
  IncomingPushDTOMapper,
  PushNotificationMessenger,
  RegisteredPushTokenDTOMapper,
  NotificationPreferencesDTOMapper,
  NotificationChannelDTOMapper,
  FirebaseExceptionMapper,
  AppleCredentialDataSource,
  GoogleCredentialDataSource,
  AudioPlayer,
  GetShouldUpdateArticleProgressStateUseCase,
];

@GenerateMocks(_classes)
// ignore: unused_element
void _() {}
