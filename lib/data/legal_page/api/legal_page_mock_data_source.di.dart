import 'package:better_informed_mobile/data/legal_page/api/legal_page_data_source.dart';
import 'package:better_informed_mobile/data/legal_page/dto/legal_page_dto.dt.dart';
import 'package:better_informed_mobile/data/util/mock_dto_creators.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: LegalPageDataSource, env: mockEnvs)
class LegalPagesMockDataSource implements LegalPageDataSource {
  @override
  Future<LegalPageDTO> getPrivacyPolicyPage() async => MockDTO.legalPage;

  @override
  Future<LegalPageDTO> getTermsOfServicePage() async => MockDTO.legalPage;
}
