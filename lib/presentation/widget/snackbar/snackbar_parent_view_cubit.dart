import 'dart:async';

import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_message.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view_state.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

const _timeoutDuration = Duration(seconds: 10);
const _messageReplaceDuration = Duration(milliseconds: 300);

@injectable
class SnackbarParentViewCubit extends Cubit<SnackbarParentViewState> {
  SnackbarParentViewCubit() : super(SnackbarParentViewState.idle());

  StreamSubscription? _timer;

  Future<void> addMessage(SnackbarMessage message) async {
    await _timer?.cancel();

    await state.map(
      idle: (_) async {
        emit(SnackbarParentViewState.message(message));
        _setupDiscardTime();
      },
      message: (state) async {
        emit(SnackbarParentViewState.idle());
        await Future.delayed(_messageReplaceDuration);
        emit(SnackbarParentViewState.message(message));
        _setupDiscardTime();
      },
    );
  }

  Future<void> discardMessage() async {
    await _timer?.cancel();
    emit(SnackbarParentViewState.idle());
  }

  void _setupDiscardTime() {
    _timer = Stream.fromFuture(Future.delayed(_timeoutDuration)).listen((event) {
      emit(SnackbarParentViewState.idle());
    });
  }

  @override
  Future<void> close() async {
    await _timer?.cancel();
    await super.close();
  }
}
