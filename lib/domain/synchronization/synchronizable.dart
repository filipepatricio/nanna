import 'package:clock/clock.dart';

class Synchronizable<T> {
  Synchronizable({
    required this.data,
    required this.createdAt,
    required this.synchronizedAt,
    required this.expirationDate,
  });

  final T data;
  final DateTime createdAt;
  final DateTime synchronizedAt;
  final DateTime expirationDate;

  bool get isExpired => expirationDate.isBefore(clock.now());
}
