import 'package:better_informed_mobile/domain/push_notification/use_case/get_notification_preferences_use_case.di.dart';
import 'package:better_informed_mobile/presentation/page/onboarding/slides/onboarding_notifications_slide/cubit/onboarding_notifications_slide_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';

@injectable
class OnboardingNotificationsSlideCubit extends Cubit<OnboardingNotificationsSlideState> {
  OnboardingNotificationsSlideCubit(this._getNotificationPreferencesUseCase)
      : super(const OnboardingNotificationsSlideState.loading());

  final GetNotificationPreferencesUseCase _getNotificationPreferencesUseCase;

  Future<void> init() async {
    try {
      final preferences = await _getNotificationPreferencesUseCase();
      emit(OnboardingNotificationsSlideState.idle(preferences: preferences));
    } catch (e, s) {
      Fimber.e('Getting notification preferences failed', ex: e, stacktrace: s);
    }
  }
}
