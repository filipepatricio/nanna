import 'package:email_validator/email_validator.dart';
import 'package:injectable/injectable.dart';

@injectable
class IsEmailValidUseCase {
  Future<bool> call(String email) async => EmailValidator.validate(email);
}
