import 'dart:math';

import 'package:injectable/injectable.dart';

const _charset = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
const _stateLength = 12;

@injectable
class AuthorizationStateGenerator {
  final _random = Random();

  String generate() {
    final randomIndexes = List.generate(_stateLength, (index) => _random.nextInt(_charset.length));
    return randomIndexes.map((index) => _charset[index]).join();
  }
}
