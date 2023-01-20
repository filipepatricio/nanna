import 'package:hive/hive.dart';

abstract class SynchronizableEntity<T> {
  SynchronizableEntity({
    required this.data,
    required this.createdAt,
    required this.synchronizedAt,
    required this.expirationDate,
  });

  @HiveField(0)
  final T data;
  @HiveField(1)
  final String createdAt;
  @HiveField(2)
  final String synchronizedAt;
  @HiveField(3)
  final String expirationDate;
}
