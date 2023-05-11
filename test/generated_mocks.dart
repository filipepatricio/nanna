import 'package:better_informed_mobile/data/analytics/incoming_push_analytics_service.di.dart';
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
import 'package:better_informed_mobile/data/push_notification/api/mapper/notification_channel_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/push_notification/api/mapper/notification_preferences_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/push_notification/api/mapper/registered_push_token_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/push_notification/api/push_notification_api_data_source.dart';
import 'package:better_informed_mobile/data/push_notification/incoming_push/mapper/incoming_push_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/push_notification/push_notification_messenger.di.dart';
import 'package:better_informed_mobile/data/subscription/api/mapper/active_subscription_mapper.di.dart';
import 'package:better_informed_mobile/data/subscription/api/mapper/subscription_origin_mapper.di.dart';
import 'package:better_informed_mobile/data/subscription/api/mapper/subscription_plan_mapper.di.dart';
import 'package:better_informed_mobile/data/subscription/api/purchase_api_data_source.dart';
import 'package:better_informed_mobile/data/subscription/api/purchase_remote_data_source.di.dart';
import 'package:better_informed_mobile/data/topic/api/mapper/topic_publisher_information_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/util/app_info_data_source.di.dart';
import 'package:better_informed_mobile/data/util/graphql_response_resolver.di.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_facade.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_repository.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/identify_analytics_user_use_case.di.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/initialize_attribution_use_case.di.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/track_activity_use_case.di.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/appearance/use_case/get_preferred_text_scale_factor_use_case.di.dart';
import 'package:better_informed_mobile/domain/article/article_local_repository.dart';
import 'package:better_informed_mobile/domain/article/article_progress_local_repository.dart';
import 'package:better_informed_mobile/domain/article/article_repository.dart';
import 'package:better_informed_mobile/domain/article/use_case/get_article_audio_progress_use_case.di.dart';
import 'package:better_informed_mobile/domain/article/use_case/get_article_use_case.di.dart';
import 'package:better_informed_mobile/domain/article/use_case/get_free_articles_left_warning_stream_use_case.di.dart';
import 'package:better_informed_mobile/domain/article/use_case/get_other_brief_entries_use_case.di.dart';
import 'package:better_informed_mobile/domain/article/use_case/get_other_topic_entries_use_case.di.dart';
import 'package:better_informed_mobile/domain/article/use_case/get_related_content_use_case.di.dart';
import 'package:better_informed_mobile/domain/article/use_case/load_local_article_use_case.di.dart';
import 'package:better_informed_mobile/domain/article/use_case/save_article_locally_use_case.di.dart';
import 'package:better_informed_mobile/domain/article/use_case/save_article_read_progress_locally_use_case.di.dart';
import 'package:better_informed_mobile/domain/article/use_case/update_article_progress_state_notifier_use_case.di.dart';
import 'package:better_informed_mobile/domain/audio/audio_repository.dart';
import 'package:better_informed_mobile/domain/audio/use_case/audio_playback_state_stream_use_case.di.dart';
import 'package:better_informed_mobile/domain/audio/use_case/audio_position_seek_use_case.di.dart';
import 'package:better_informed_mobile/domain/audio/use_case/audio_position_stream_use_case.di.dart';
import 'package:better_informed_mobile/domain/auth/auth_repository.dart';
import 'package:better_informed_mobile/domain/auth/auth_store.dart';
import 'package:better_informed_mobile/domain/auth/use_case/is_signed_in_use_case.di.dart';
import 'package:better_informed_mobile/domain/auth/use_case/send_magic_link_use_case.di.dart';
import 'package:better_informed_mobile/domain/auth/use_case/subscribe_for_magic_link_token_use_case.di.dart';
import 'package:better_informed_mobile/domain/bookmark/bookmark_change_notifier.di.dart';
import 'package:better_informed_mobile/domain/bookmark/bookmark_local_repository.dart';
import 'package:better_informed_mobile/domain/bookmark/bookmark_remote_repository.dart';
import 'package:better_informed_mobile/domain/bookmark/profile_bookmark_change_notifier.di.dart';
import 'package:better_informed_mobile/domain/bookmark/use_case/get_bookmark_state_use_case.di.dart';
import 'package:better_informed_mobile/domain/bookmark/use_case/get_paginated_bookmarks_use_case.di.dart';
import 'package:better_informed_mobile/domain/bookmark/use_case/save_bookmarked_media_item_use_case.di.dart';
import 'package:better_informed_mobile/domain/categories/use_case/get_featured_categories_use_case.di.dart';
import 'package:better_informed_mobile/domain/categories/use_case/is_add_interests_page_seen_use_case.di.dart';
import 'package:better_informed_mobile/domain/categories/use_case/set_add_interests_page_seen_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/use_case/brief_entry_new_state_notifier.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/use_case/decrease_brief_unseen_count_state_notifier_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/use_case/get_current_brief_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/use_case/get_past_brief_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/use_case/get_should_update_brief_stream_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/use_case/mark_entry_as_seen_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/use_case/notify_brief_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/use_case/save_seen_entry_locally_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief_badge/badge_info_repository.dart';
import 'package:better_informed_mobile/domain/daily_brief_badge/use_case/should_show_daily_brief_badge_use_case.di.dart';
import 'package:better_informed_mobile/domain/deep_link/deep_link_repository.dart';
import 'package:better_informed_mobile/domain/feature_flags/feature_flags_repository.dart';
import 'package:better_informed_mobile/domain/feature_flags/use_case/initialize_feature_flags_use_case.di.dart';
import 'package:better_informed_mobile/domain/feature_flags/use_case/should_use_observable_queries_use_case.di.dart';
import 'package:better_informed_mobile/domain/feature_flags/use_case/should_use_text_size_selector_use_case.di.dart';
import 'package:better_informed_mobile/domain/general/is_email_valid_use_case.di.dart';
import 'package:better_informed_mobile/domain/networking/connectivity_repository.dart';
import 'package:better_informed_mobile/domain/networking/use_case/is_internet_connection_available_use_case.di.dart';
import 'package:better_informed_mobile/domain/permissions/permissions_repository.dart';
import 'package:better_informed_mobile/domain/push_notification/push_notification_repository.dart';
import 'package:better_informed_mobile/domain/push_notification/push_notification_store.dart';
import 'package:better_informed_mobile/domain/push_notification/use_case/background_incoming_push_data_refresh_stream_use_case.di.dart';
import 'package:better_informed_mobile/domain/push_notification/use_case/has_notification_permission_use_case.di.dart';
import 'package:better_informed_mobile/domain/push_notification/use_case/incoming_push_brief_entries_updated_stream_use_case.di.dart';
import 'package:better_informed_mobile/domain/push_notification/use_case/incoming_push_data_refresh_stream_use_case.di.dart';
import 'package:better_informed_mobile/domain/release_notes/release_notes_local_repository.dart';
import 'package:better_informed_mobile/domain/release_notes/release_notes_remote_repository.dart';
import 'package:better_informed_mobile/domain/release_notes/use_case/save_release_note_if_first_run_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';
import 'package:better_informed_mobile/domain/subscription/purchases_repository.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/force_subscription_status_sync_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_active_subscription_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_preferred_subscription_plan_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_subscription_plans_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/has_active_subscription_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/initialize_purchases_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/purchase_subscription_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/restore_purchase_use_case.di.dart';
import 'package:better_informed_mobile/domain/synchronization/synchronizable_repository.dart';
import 'package:better_informed_mobile/domain/synchronization/use_case/run_initial_bookmark_sync_use_case.di.dart';
import 'package:better_informed_mobile/domain/synchronization/use_case/save_synchronizable_item_use_case.di.dart';
import 'package:better_informed_mobile/domain/synchronization/use_case/synchronize_with_remote_use_case.di.dart';
import 'package:better_informed_mobile/domain/topic/topics_repository.dart';
import 'package:better_informed_mobile/domain/topic/use_case/save_topic_locally_use_case.di.dart';
import 'package:better_informed_mobile/domain/tutorial/use_case/is_tutorial_step_seen_use_case.di.dart';
import 'package:better_informed_mobile/domain/tutorial/use_case/set_tutorial_step_seen_use_case.di.dart';
import 'package:better_informed_mobile/domain/user/use_case/clear_guest_mode_use_case.di.dart';
import 'package:better_informed_mobile/domain/user/use_case/get_category_preferences_use_case.di.dart';
import 'package:better_informed_mobile/domain/user/use_case/get_user_use_case.di.dart';
import 'package:better_informed_mobile/domain/user/use_case/is_guest_mode_use_case.di.dart';
import 'package:better_informed_mobile/domain/user_store/user_store.dart';
import 'package:better_informed_mobile/domain/util/app_info_repository.dart';
import 'package:better_informed_mobile/domain/util/network_cache_manager.dart';
import 'package:better_informed_mobile/domain/util/use_case/open_subscription_management_screen_use_case.di.dart';
import 'package:better_informed_mobile/domain/util/use_case/request_permissions_use_case.di.dart';
import 'package:better_informed_mobile/domain/util/use_case/set_needs_refresh_daily_brief_use_case.di.dart';
import 'package:better_informed_mobile/domain/util/use_case/should_refresh_daily_brief_use_case.di.dart';
import 'package:better_informed_mobile/domain/util/use_case/should_update_app_use_case.di.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fresh_graphql/fresh_graphql.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mockito/annotations.dart';
import 'package:purchases_flutter/object_wrappers.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _classes = [
  AudioRepository,
  ArticleRepository,
  AnalyticsRepository,
  CuratorDTOMapper,
  PublisherDTOMapper,
  ImageDTOMapper,
  EntryDTOMapper,
  TopicPublisherInformationDTOMapper,
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
  BackgroundIncomingPushDataRefreshStreamUseCase,
  GetPastBriefUseCase,
  AudioPlaybackStateStreamUseCase,
  AudioPositionStreamUseCase,
  AudioPositionSeekUseCase,
  GetArticleAudioProgressUseCase,
  GetShouldUpdateBriefStreamUseCase,
  HasActiveSubscriptionUseCase,
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
  IncomingPushAnalyticsService,
  UpdateArticleProgressStateNotifierUseCase,
  AnalyticsFacade,
  SaveBookmarkedMediaItemUseCase,
  BookmarkLocalRepository,
  ProfileBookmarkChangeNotifier,
  TopicsRepository,
  SaveArticleLocallyUseCase,
  SaveTopicLocallyUseCase,
  SynchronizableRepository,
  SynchronizeWithRemoteUsecase,
  SaveSynchronizableItemUseCase,
  GetFreeArticlesLeftWarningStreamUseCase,
  IsInternetConnectionAvailableUseCase,
  ArticleLocalRepository,
  ArticleProgressLocalRepository,
  SaveArticleReadProgressLocallyUseCase,
  LoadLocalArticleUseCase,
  ShouldRefreshDailyBriefUseCase,
  IncomingPushBriefEntriesUpdatedStreamUseCase,
  GetBookmarkStateUseCase,
  ConnectivityRepository,
  ShouldShowDailyBriefBadgeUseCase,
  OpenSubscriptionManagementScreenUseCase,
  SubscriptionOriginMapper,
  MarkEntryAsSeenUseCase,
  SaveSeenEntryLocallyUseCase,
  BriefEntryNewStateNotifier,
  DecreaseBriefUnseenCountStateNotifierUseCase,
  BadgeInfoRepository,
  SharedPreferences,
  GetPaginatedBookmarksUseCase,
  ShouldUseObservableQueriesUseCase,
  IncomingPushDataRefreshStreamUseCase,
  SetNeedsRefreshDailyBriefUseCase,
  ShouldUseTextSizeSelectorUseCase,
  GetPreferredArticleTextScaleFactorUseCase,
  GetOtherTopicEntriesUseCase,
  GetOtherBriefEntriesUseCase,
  GetFeaturedCategoriesUseCase,
  GetRelatedContentUseCase,
  GetArticleUseCase,
  IsSignedInUseCase,
  InitializeFeatureFlagsUseCase,
  InitializeAttributionUseCase,
  SaveReleaseNoteIfFirstRunUseCase,
  IdentifyAnalyticsUserUseCase,
  InitializePurchasesUseCase,
  AuthRepository,
  UserStore,
  GetUserUseCase,
  RunIntitialBookmarkSyncUseCase,
  SubscribeForMagicLinkTokenUseCase,
  SendMagicLinkUseCase,
  IsEmailValidUseCase,
  ShouldUpdateAppUseCase,
  RestorePurchaseUseCase,
  IsAddInterestsPageSeenUseCase,
  SetAddInterestsPageSeenUseCase,
  GetCategoryPreferencesUseCase,
  UpdateBriefNotifierUseCase,
  PermissionsRepository,
  RequestPermissionsUseCase,
  HasNotificationPermissionUseCase,
  PurchaseApiDataSource,
  ForceSubscriptionStatusSyncUseCase,
  IsGuestModeUseCase,
  ClearGuestModeUseCase,
];

@GenerateMocks(_classes)
// ignore: unused_element
void _() {}
