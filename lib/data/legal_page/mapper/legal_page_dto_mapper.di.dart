import 'package:better_informed_mobile/data/legal_page/dto/legal_page_dto.dt.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/legal_page/data/legal_page.dart';
import 'package:injectable/injectable.dart';

@injectable
class LegalPageDTOMapper implements Mapper<LegalPageDTO, LegalPage> {
  @override
  LegalPage call(LegalPageDTO data) {
    return LegalPage(
      title: data.title,
      content: data.content,
    );
  }
}
