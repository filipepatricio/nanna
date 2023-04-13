import 'package:better_informed_mobile/data/legal_page/api/legal_page_data_source.dart';
import 'package:better_informed_mobile/data/legal_page/mapper/legal_page_dto_mapper.di.dart';
import 'package:better_informed_mobile/domain/legal_page/data/legal_page.dart';
import 'package:better_informed_mobile/domain/legal_page/legal_page_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: LegalPageRepository)
class LegalPageRepositoryImpl implements LegalPageRepository {
  LegalPageRepositoryImpl(
    this._dataSource,
    this._mapper,
  );

  final LegalPageDataSource _dataSource;
  final LegalPageDTOMapper _mapper;

  @override
  Future<LegalPage> getPrivacyPolicyPage() async {
    final dto = await _dataSource.getPrivacyPolicyPage();

    return _mapper(dto);
  }

  @override
  Future<LegalPage> getTermsOfServicePage() async {
    final dto = await _dataSource.getTermsOfServicePage();

    return _mapper(dto);
  }
}
