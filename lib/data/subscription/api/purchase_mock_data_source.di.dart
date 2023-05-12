import 'package:better_informed_mobile/data/common/dto/successful_response_dto.dt.dart';
import 'package:better_informed_mobile/data/subscription/api/purchase_api_data_source.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: PurchaseApiDataSource, env: mockEnvs)
class PurchaseMockDataSource implements PurchaseApiDataSource {
  @override
  Future<SuccessfulResponseDTO> forceSubscriptionStatusSync() async {
    return SuccessfulResponseDTO(true);
  }
}
