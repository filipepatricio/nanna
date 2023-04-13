import 'package:better_informed_mobile/domain/legal_page/data/legal_page.dart';

abstract class LegalPageRepository {
  Future<LegalPage> getTermsOfServicePage();

  Future<LegalPage> getPrivacyPolicyPage();
}
