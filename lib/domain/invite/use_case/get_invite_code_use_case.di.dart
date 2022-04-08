import 'package:better_informed_mobile/domain/invite/data/invite_code.dart';
import 'package:better_informed_mobile/domain/invite/invite_remote_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetInviteCodeUseCase {
  GetInviteCodeUseCase(this._inviteRemoteRepository);

  final InviteRemoteRepository _inviteRemoteRepository;

  Future<InviteCode> call() => _inviteRemoteRepository.getInviteCode();
}
