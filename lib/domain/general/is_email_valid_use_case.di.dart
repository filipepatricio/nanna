import 'package:email_validator/email_validator.dart';
import 'package:injectable/injectable.dart';

@injectable
class IsEmailValidUseCase {
  bool call(String email) => EmailValidator.validate(email);
}
