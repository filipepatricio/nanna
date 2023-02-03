import 'package:clock/clock.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'synchronizable.dt.freezed.dart';

@freezed
class Synchronizable<T> with _$Synchronizable<T> {
  factory Synchronizable.synchronized({
    required T data,
    required String dataId,
    required DateTime createdAt,
    required DateTime synchronizedAt,
    required DateTime expirationDate,
  }) = Synchronized<T>;

  factory Synchronizable.notSynchronized({
    required String dataId,
    required DateTime createdAt,
    required DateTime expirationDate,
  }) = NotSynchronized<T>;

  const Synchronizable._();

  static Synchronizable<T> createSynchronized<T>(T data, String dataId, Duration timeToExpire) {
    final date = clock.now();

    return Synchronizable<T>.synchronized(
      data: data,
      dataId: dataId,
      createdAt: date,
      synchronizedAt: date,
      expirationDate: date.add(timeToExpire),
    );
  }

  static Synchronizable<T> createNotSynchronized<T>(String dataId, Duration timeToExpire) {
    final date = clock.now();

    return Synchronizable<T>.notSynchronized(
      dataId: dataId,
      createdAt: date,
      expirationDate: date.add(timeToExpire),
    );
  }

  bool get isExpired => expirationDate.isBefore(clock.now());

  T? get maybeData {
    return map(
      synchronized: (synchronized) => synchronized.data,
      notSynchronized: (_) => null,
    );
  }

  DateTime? get maybeSynchronizedAt {
    return map(
      synchronized: (synchronized) => synchronized.synchronizedAt,
      notSynchronized: (_) => null,
    );
  }

  Synchronizable<T> synchronize(T data) {
    return map(
      synchronized: (synchronized) => synchronized.copyWith(data: data, synchronizedAt: clock.now()),
      notSynchronized: (notSynchronized) => notSynchronized.makeSynchronized(data),
    );
  }
}

extension on NotSynchronized {
  Synchronizable<T> makeSynchronized<T>(T data) {
    return Synchronizable<T>.synchronized(
      data: data,
      dataId: dataId,
      createdAt: createdAt,
      synchronizedAt: clock.now(),
      expirationDate: expirationDate,
    );
  }
}
