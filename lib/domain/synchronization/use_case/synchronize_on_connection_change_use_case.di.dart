import 'dart:async';

import 'package:better_informed_mobile/domain/networking/use_case/is_internet_connection_available_use_case.di.dart';
import 'package:better_informed_mobile/domain/synchronization/use_case/synchronize_all_use_case.di.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@injectable
class SynchronizeOnConnectionChangeUseCase {
  SynchronizeOnConnectionChangeUseCase(
    this._synchronizeAllUseCase,
    this._isInternetConnectionAvailableUseCase,
  );

  final SynchronizeAllUseCase _synchronizeAllUseCase;
  final IsInternetConnectionAvailableUseCase _isInternetConnectionAvailableUseCase;

  StreamSubscription call() {
    return _isInternetConnectionAvailableUseCase.stream
        .distinct()
        .debounceTime(const Duration(seconds: 5))
        .where((isAvailable) => isAvailable)
        .listen((event) => _synchronizeAllUseCase());
  }
}
