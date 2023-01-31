import 'dart:async';

import 'package:better_informed_mobile/domain/networking/use_case/is_internet_connection_available_use_case.di.dart';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';

mixin ConnectionStateAwareCubitMixin<S, I> on Cubit<S> {
  abstract final IsInternetConnectionAvailableUseCase isInternetConnectionAvailableUseCase;

  bool? isCurrentlyOnline;
  StreamSubscription<bool>? _connectionStateSubscription;

  @override
  Future<void> close() {
    _connectionStateSubscription?.cancel();
    return super.close();
  }

  Future<void> initializeConnection(I initialData) async {
    await _connectionStateSubscription?.cancel();
    _connectionStateSubscription = isInternetConnectionAvailableUseCase.stream
        .distinct()
        .debounceTime(const Duration(milliseconds: 250))
        .listen((isOnline) => _handleConnectionState(initialData, isOnline));

    final isOnline = await isInternetConnectionAvailableUseCase();
    await _handleConnectionState(initialData, isOnline);
  }

  Future<void> _handleConnectionState(I initialData, bool isOnline) async {
    if (isCurrentlyOnline == isOnline) return;
    isCurrentlyOnline = isOnline;

    if (isOnline) {
      await onOnline(initialData);
    } else {
      await onOffline(initialData);
    }
  }

  Future<void> onOffline(I initialData);

  Future<void> onOnline(I initialData);
}
