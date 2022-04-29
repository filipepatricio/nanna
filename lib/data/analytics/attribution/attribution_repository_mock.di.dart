import 'package:better_informed_mobile/domain/analytics/attribution_repository.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(
  as: AttributionRepository,
  env: [
    Environment.dev,
    mockName,
  ],
)
class AttributionRepositoryMock implements AttributionRepository {
  @override
  Future<void> initialize() async {}
}
