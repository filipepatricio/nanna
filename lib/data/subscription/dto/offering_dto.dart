import 'package:purchases_flutter/object_wrappers.dart';

class OfferingDTO {
  const OfferingDTO({
    required this.offering,
    required this.isFirstTimeSubscriber,
  });

  final Offering offering;
  final bool isFirstTimeSubscriber;
}
