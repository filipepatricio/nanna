import 'package:better_informed_mobile/domain/user/data/user.dart';

User anUser([
  String? uuid,
  String? firstName,
  String? lastName,
  String? email,
]) =>
    User(
      uuid: uuid ?? '1',
      firstName: firstName ?? 'User',
      lastName: lastName ?? 'Test',
      email: email ?? 'test@betterinformed.io',
    );
