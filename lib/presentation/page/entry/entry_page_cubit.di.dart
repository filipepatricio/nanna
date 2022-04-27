import 'package:better_informed_mobile/domain/analytics/use_case/initialize_attribution_use_case.di.dart';
import 'package:better_informed_mobile/domain/auth/use_case/is_signed_in_use_case.di.dart';
import 'package:better_informed_mobile/domain/feature_flags/use_case/initialize_feature_flags_use_case.di.dart';
import 'package:better_informed_mobile/presentation/page/entry/entry_page_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class EntryPageCubit extends Cubit<EntryPageState> {
  final IsSignedInUseCase _isSignedInUseCase;
  final InitializeFeatureFlagsUseCase _initializeFeatureFlagsUseCase;
  final InitializeAttributionUseCase _initializeAttributionUseCase;

  EntryPageCubit(
    this._isSignedInUseCase,
    this._initializeFeatureFlagsUseCase,
    this._initializeAttributionUseCase,
  ) : super(EntryPageState.idle());

  Future<void> initialize() async {
    final signedIn = await _isSignedInUseCase();
    if (signedIn) {
      await _initializeFeatureFlagsUseCase();
      await _initializeAttributionUseCase();
    }
    emit(signedIn ? EntryPageState.alreadySignedIn() : EntryPageState.notSignedIn());
  }
}
