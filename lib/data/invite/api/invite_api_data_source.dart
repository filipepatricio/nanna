import 'package:better_informed_mobile/data/invite/dto/invite_code_dto.dart';

abstract class InviteApiDataSource {
  Future<InviteCodeDTO> getInviteCode();
}
