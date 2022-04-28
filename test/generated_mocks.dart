import 'package:better_informed_mobile/data/article/api/mapper/publisher_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/image/api/mapper/image_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/onboarding/mapper/onboarding_version_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/onboarding/store/onboarding_database.dart';
import 'package:better_informed_mobile/data/topic/api/mapper/reading_list_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/topic/api/mapper/summary_card_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/topic/api/mapper/topic_owner_dto_mapper.di.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_repository.dart';
import 'package:better_informed_mobile/domain/article/article_repository.dart';
import 'package:better_informed_mobile/domain/audio/audio_repository.dart';
import 'package:mockito/annotations.dart';

const _classes = [
  AudioRepository,
  ArticleRepository,
  AnalyticsRepository,
  TopicOwnerDTOMapper,
  PublisherDTOMapper,
  ImageDTOMapper,
  ReadingListDTOMapper,
  SummaryCardDTOMapper,
  OnboardingDatabase,
  OnboardingVersionEntityMapper,
];

@GenerateMocks(_classes)
// ignore: unused_element
void _() {}
