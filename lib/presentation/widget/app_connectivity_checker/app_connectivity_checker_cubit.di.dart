import 'dart:async';

import 'package:better_informed_mobile/domain/networking/use_case/is_internet_connection_available_use_case.di.dart';
import 'package:better_informed_mobile/presentation/widget/app_connectivity_checker/app_connectivity_checker_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class AppConnectivityCheckerCubit extends Cubit<AppConnectivityCheckerState> {
  AppConnectivityCheckerCubit(
    this._isInternetConnectionAvailableUseCase,
  ) : super(AppConnectivityCheckerState.connected());

  final IsInternetConnectionAvailableUseCase _isInternetConnectionAvailableUseCase;

  bool? _isConnected;

  StreamSubscription? _connectionStateSubscription;

  @override
  Future<void> close() async {
    await _connectionStateSubscription?.cancel();
    await super.close();
  }

  Future<void> initialize() async {
    await checkIsConnected();
    _connectionStateSubscription = _isInternetConnectionAvailableUseCase.stream.listen((isConnectionAvailable) {
      _isConnected = isConnectionAvailable;
      _updateConnectionState(_isConnected!);
    });
  }

  Future<bool> checkIsConnected() async {
    _isConnected = await _isInternetConnectionAvailableUseCase();
    _updateConnectionState(_isConnected!);
    return _isConnected!;
  }

  void _updateConnectionState(bool isConnected) {
    if (!isConnected) {
      emit(const AppConnectivityCheckerState.notConnected());
      return;
    }

    emit(AppConnectivityCheckerState.connected());
  }
}
