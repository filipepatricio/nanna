import 'package:better_informed_mobile/domain/analytics/use_case/initialize_attribution_use_case.di.dart';
import 'package:better_informed_mobile/domain/auth/use_case/is_signed_in_use_case.di.dart';
import 'package:better_informed_mobile/domain/exception/unauthorized_exception.dart';
import 'package:better_informed_mobile/domain/feature_flags/use_case/initialize_feature_flags_use_case.di.dart';
import 'package:better_informed_mobile/domain/onboarding/use_case/is_onboarding_seen_use_case.di.dart';
import 'package:better_informed_mobile/presentation/page/entry/entry_page_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class EntryPageCubit extends Cubit<EntryPageState> {
  final IsSignedInUseCase _isSignedInUseCase;
  final InitializeFeatureFlagsUseCase _initializeFeatureFlagsUseCase;
  final InitializeAttributionUseCase _initializeAttributionUseCase;
  final IsOnboardingSeenUseCase _isOnboardingSeenUseCase;

  EntryPageCubit(
    this._isSignedInUseCase,
    this._initializeFeatureFlagsUseCase,
    this._initializeAttributionUseCase,
    this._isOnboardingSeenUseCase,
  ) : super(EntryPageState.idle());

  Future<void> initialize() async {
    final signedIn = await _isSignedInUseCase();
    if (signedIn) {
      try {
        await _initializeFeatureFlagsUseCase();
      } on UnauthorizedException {
        emit(EntryPageState.notSignedIn());
        return;
      }

      final onboardingSeen = await _isOnboardingSeenUseCase();
      if (onboardingSeen) {
        await _initializeAttributionUseCase();
      } else {
        emit(EntryPageState.onboarding());
        return;
      }
    }

    emit(signedIn ? EntryPageState.alreadySignedIn() : EntryPageState.notSignedIn());
  }
}
