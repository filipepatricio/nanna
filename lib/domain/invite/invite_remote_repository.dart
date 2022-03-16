import 'package:better_informed_mobile/domain/invite/data/invite_code.dart';

abstract class InviteRemoteRepository {
  Future<InviteCode> getInviteCode();
}
