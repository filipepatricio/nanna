import 'package:better_informed_mobile/domain/feature_flags/feature_flags_repository.dart';
import 'package:better_informed_mobile/domain/util/network_cache_manager.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@injectable
class UsePaidSubscriptionChangeStreamUseCase {
  UsePaidSubscriptionChangeStreamUseCase(
    this._featuresFlagsRepository,
    this._networkCacheManager,
  );

  final FeaturesFlagsRepository _featuresFlagsRepository;
  final NetworkCacheManager _networkCacheManager;

  Stream<bool> call() {
    return Rx.concat([
      _featuresFlagsRepository.usePaidSubscriptions().asStream(),
      _featuresFlagsRepository.usePaidSubscriptionStream(),
    ]).distinct().skip(1).asyncMap((event) async {
      await _networkCacheManager.clear();
      return event;
    });
  }
}
