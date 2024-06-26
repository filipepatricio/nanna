import 'package:better_informed_mobile/data/subscription/database/entity/active_subscription_entity.hv.dart';
import 'package:better_informed_mobile/data/subscription/database/mapper/active_subscription_entity_mapper.di.dart';
import 'package:better_informed_mobile/domain/subscription/data/active_subscription.dt.dart';
import 'package:better_informed_mobile/domain/subscription/subscription_local_repository.dart';
import 'package:hive/hive.dart';

const _onboardingBoxName = 'subscriptionBox';

const _subscriptionBoxName = 'active_sub';
const _subscriptionKey = 'active';

class SubscriptionHiveLocalRepository extends SubscriptionLocalRepository {
  SubscriptionHiveLocalRepository._(
    this._subscriptionBox,
    this._activeSubscriptionEntityMapper,
  );

  final ActiveSubscriptionEntityMapper _activeSubscriptionEntityMapper;
  final LazyBox<ActiveSubscriptionEntity> _subscriptionBox;

  static Future<SubscriptionHiveLocalRepository> create(
    ActiveSubscriptionEntityMapper activeSubscriptionEntityMapper,
  ) async {
    final subscriptionBox = await Hive.openLazyBox<ActiveSubscriptionEntity>(_subscriptionBoxName);

    return SubscriptionHiveLocalRepository._(
      subscriptionBox,
      activeSubscriptionEntityMapper,
    );
  }

  @override
  Future<void> clear(String userUuid) async {
    final box = await _openOnboardingBox(userUuid);
    await box.clear();
    await _subscriptionBox.clear();
  }

  @override
  Future<ActiveSubscription?> loadActiveSubscription() async {
    ActiveSubscriptionEntity? activeSubscriptionEntity;

    try {
      activeSubscriptionEntity = await _subscriptionBox.get(_subscriptionKey);
    } on RangeError {
      // If saved structure is outdated or corrupt, clear box
      await _subscriptionBox.clear();
      return null;
    }

    if (activeSubscriptionEntity == null) return null;

    return _activeSubscriptionEntityMapper.to(activeSubscriptionEntity);
  }

  @override
  Future<void> saveActiveSubscription(ActiveSubscription activeSubscription) async {
    final activeSubscriptionEntity = _activeSubscriptionEntityMapper.from(activeSubscription);
    await _subscriptionBox.put(_subscriptionKey, activeSubscriptionEntity);
  }

  Future<Box<bool>> _openOnboardingBox(String userUuid) async {
    return Hive.openBox<bool>('${userUuid}_$_onboardingBoxName');
  }
}
