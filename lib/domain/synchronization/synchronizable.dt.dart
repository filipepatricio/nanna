import 'package:clock/clock.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'synchronizable.dt.freezed.dart';

@freezed
class Synchronizable<T> with _$Synchronizable<T> {
  factory Synchronizable({
    required T? data,
    required String dataId,
    required DateTime createdAt,
    required DateTime? synchronizedAt,
    required DateTime expirationDate,
  }) = _Synchronizable<T>;

  const Synchronizable._();

  static Synchronizable<T> synchronized<T>(T data, String dataId, Duration timeToExpire) {
    final date = clock.now();

    return Synchronizable<T>(
      data: data,
      dataId: dataId,
      createdAt: date,
      synchronizedAt: date,
      expirationDate: date.add(timeToExpire),
    );
  }

  static Synchronizable<T> notSynchronized<T>(String dataId, Duration timeToExpire) {
    final date = clock.now();

    return Synchronizable<T>(
      dataId: dataId,
      createdAt: date,
      expirationDate: date.add(timeToExpire),
      data: null,
      synchronizedAt: null,
    );
  }

  bool get isExpired => expirationDate.isBefore(clock.now());

  bool get isNotSynchronized => synchronizedAt == null;
}
