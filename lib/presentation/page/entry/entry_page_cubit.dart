import 'package:better_informed_mobile/domain/auth/use_case/is_signed_in_use_case.dart';
import 'package:better_informed_mobile/presentation/page/entry/entry_page_state.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class EntryPageCubit extends Cubit<EntryPageState> {
  final IsSignedInUseCase _isSignedInUseCase;

  EntryPageCubit(this._isSignedInUseCase) : super(EntryPageState.idle());

  Future<void> initialize() async {
    final signedIn = await _isSignedInUseCase();
    emit(signedIn ? EntryPageState.alreadySignedIn() : EntryPageState.notSignedIn());
  }
}
