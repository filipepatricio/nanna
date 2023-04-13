import 'package:better_informed_mobile/domain/legal_page/data/legal_page.dart';
import 'package:better_informed_mobile/domain/legal_page/legal_page_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetPrivacyPolicyLegalPageUseCase {
  GetPrivacyPolicyLegalPageUseCase(this._legalPageRepository);

  final LegalPageRepository _legalPageRepository;

  Future<LegalPage> call() => _legalPageRepository.getPrivacyPolicyPage();
}
