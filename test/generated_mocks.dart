import 'package:better_informed_mobile/data/article/api/mapper/publisher_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/auth/api/auth_api_data_source.dart';
import 'package:better_informed_mobile/data/auth/api/mapper/auth_token_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/auth/api/mapper/login_response_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/auth/api/provider/linkedin/linkedin_credential_data_source.di.dart';
import 'package:better_informed_mobile/data/auth/api/provider/oauth_credential_provider_data_source.di.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/entry_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/image/api/mapper/image_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/onboarding/mapper/onboarding_version_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/onboarding/store/onboarding_database.dart';
import 'package:better_informed_mobile/data/topic/api/mapper/summary_card_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/topic/api/mapper/topic_owner_dto_mapper.di.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_repository.dart';
import 'package:better_informed_mobile/domain/article/article_repository.dart';
import 'package:better_informed_mobile/domain/audio/audio_repository.dart';
import 'package:fresh_graphql/fresh_graphql.dart';
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
];

@GenerateMocks(_classes)
// ignore: unused_element
void _() {}
