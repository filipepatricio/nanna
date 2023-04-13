import 'package:better_informed_mobile/data/legal_page/dto/legal_page_dto.dt.dart';

abstract class LegalPageDataSource {
  Future<LegalPageDTO> getTermsOfServicePage();

  Future<LegalPageDTO> getPrivacyPolicyPage();
}
