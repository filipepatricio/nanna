import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_message.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view_state.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class SnackbarParentViewCubit extends Cubit<SnackbarParentViewState> {
  SnackbarParentViewCubit() : super(SnackbarParentViewState.idle());

  Future<void> addMessage(SnackbarMessage message) async {
    await state.map(
      idle: (_) async {
        emit(SnackbarParentViewState.message(message));
      },
      message: (state) async {
        emit(SnackbarParentViewState.idle());
        await Future.delayed(const Duration(milliseconds: 300));
        emit(SnackbarParentViewState.message(message));
      },
    );
  }

  void discardMessage() {
    emit(SnackbarParentViewState.idle());
  }
}
