import 'package:better_informed_mobile/data/invite/dto/invite_code_dto.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/invite/data/invite_code.dart';
import 'package:injectable/injectable.dart';

@injectable
class InviteCodeDTOMapper implements Mapper<InviteCodeDTO, InviteCode> {
  @override
  InviteCode call(InviteCodeDTO data) {
    return InviteCode(
      id: data.id,
      code: data.code,
      useCount: data.useCount,
      maxUseCount: data.maxUseCount,
    );
  }
}
