import 'package:better_informed_mobile/domain/auth/use_case/send_magic_link_use_case.dart';
import 'package:better_informed_mobile/domain/auth/use_case/sign_in_with_default_provider_use_case.dart';
import 'package:better_informed_mobile/domain/general/is_email_valid_use_case.dart';
import 'package:better_informed_mobile/presentation/page/sign_in/sign_in_page_state.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class SignInPageCubit extends Cubit<SignInPageState> {
  final IsEmailValidUseCase _isEmailValidUseCase;
  final SendMagicLinkUseCase _sendMagicLinkUseCase;
  final SignInWithDefaultProviderUseCase _signInWithDefaultProviderUseCase;

  late String _email;

  SignInPageCubit(
    this._isEmailValidUseCase,
    this._sendMagicLinkUseCase,
    this._signInWithDefaultProviderUseCase,
  ) : super(SignInPageState.idle(false));

  Future<void> updateEmail(String email) async {
    _email = email;
    final valid = await _isEmailValidUseCase(email);
    emit(SignInPageState.idle(valid));
  }

  Future<void> sendMagicLink() async {
    await _sendMagicLinkUseCase(_email);
    emit(SignInPageState.magicLink());
  }

  Future<void> signInWithProvider() async {
    await _signInWithDefaultProviderUseCase();
  }
}
