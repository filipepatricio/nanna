import 'package:better_informed_mobile/data/common/dto/successful_response_dto.dt.dart';

abstract class PurchaseApiDataSource {
  Future<SuccessfulResponseDTO> forceSubscriptionStatusSync();
}
