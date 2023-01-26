import 'dart:async';

import 'package:better_informed_mobile/domain/bookmark/data/bookmark_type_data.dt.dart';
import 'package:better_informed_mobile/domain/networking/use_case/is_internet_connection_available_use_case.di.dart';
import 'package:better_informed_mobile/presentation/widget/informed_app_bar/informed_app_bar_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class InformedAppBarCubit extends Cubit<InformedAppBarState> {
  InformedAppBarCubit(
    this._isInternetConnectionAvailableUseCase,
  ) : super(InformedAppBarState.idle());

  final IsInternetConnectionAvailableUseCase _isInternetConnectionAvailableUseCase;

  StreamSubscription? _connectionSubscription;

  @override
  Future<void> close() {
    _connectionSubscription?.cancel();
    return super.close();
  }

  Future<void> initialize(BookmarkTypeData data) async {
    final isConnected = await _isInternetConnectionAvailableUseCase();
    emitState(isConnected);

    _connectionSubscription = _isInternetConnectionAvailableUseCase.stream.listen(emitState);
  }

  void emitState(bool isConnected) {
    if (isConnected) {
      emit(InformedAppBarState.idle());
      return;
    }

    emit(InformedAppBarState.noConnection());
  }
}
