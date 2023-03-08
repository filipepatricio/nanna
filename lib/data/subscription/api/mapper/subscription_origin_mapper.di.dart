import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_origin.dart';
import 'package:injectable/injectable.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

@injectable
class SubscriptionOriginMapper extends Mapper<Store, SubscriptionOrigin> {
  @override
  SubscriptionOrigin call(Store data) {
    switch (data) {
      case Store.appStore:
        return SubscriptionOrigin.appStore;
      case Store.playStore:
        return SubscriptionOrigin.playStore;
      default:
        return SubscriptionOrigin.unknown;
    }
  }
}
