import 'package:better_informed_mobile/data/invite/api/invite_api_data_source.dart';
import 'package:better_informed_mobile/data/invite/dto/invite_code_dto.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: InviteApiDataSource, env: mockEnvs)
class InviteMockApiDataSource implements InviteApiDataSource {
  @override
  Future<InviteCodeDTO> getInviteCode() async {
    return InviteCodeDTO(
      id: '000',
      code: 'YDG3T5',
      maxUseCount: 3,
      useCount: 2,
    );
  }
}
