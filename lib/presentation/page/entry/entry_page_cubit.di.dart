import 'package:better_informed_mobile/domain/auth/use_case/is_signed_in_use_case.di.dart';
import 'package:better_informed_mobile/domain/feature_flags/use_case/initialize_feature_flags_use_case.di.dart';
import 'package:better_informed_mobile/presentation/page/entry/entry_page_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class EntryPageCubit extends Cubit<EntryPageState> {
  final IsSignedInUseCase _isSignedInUseCase;
  final InitializeFeatureFlagsUseCase _initializeFeatureFlagsUseCase;

  EntryPageCubit(
    this._isSignedInUseCase,
    this._initializeFeatureFlagsUseCase,
  ) : super(EntryPageState.idle());

  Future<void> initialize() async {
    final signedIn = await _isSignedInUseCase();
    if (signedIn) {
      await _initializeFeatureFlagsUseCase();
    }
    emit(signedIn ? EntryPageState.alreadySignedIn() : EntryPageState.notSignedIn());
  }
}
